#include <amxmodx>
#include <amxmisc>
#include <ColorChat>
#include <amxxpro_discord>

#pragma compress 1

new const PLUGIN[] = "Discord Reports"
new const VERSION[] = "1.1"
new const AUTHOR[] = "N1K1Cz | AmxxPro.pl"
new const URL_AUTHOR[] = "https://amxxpro.pl"
new const DESCRIPTION[] = "System zgloszen graczy zintegrowany z serwerem Discord"

enum _:ENUMS
{
    STEAMID,
    NAMEID,
    IPID,
    STEAMTARGET,
    NAMETARGET,
    IPTARGET,
    LENGTH
}

new const repCommands[][] = { "say /zglos", "say_team /zglos" }

enum _:Cvars { prefix[64], interval, report_flag[8], report_admin, show_admin, show_time, show_map, show_reason, 
               my_reason, show_player, show_ping, id_ranga[512], bot_name[64], bot_avatar[64], title[64], show_footer_img,
               footer_img[64], color[32], thumbnail_img[64], show_thumbnail_img }
new gTarget[33], gReason[33][192], rMenu, mapname[32], buffer[ENUMS][128], gTime[9], amxxpro_discord[Cvars];
new Trie: AntiF, AntiFlood[33];

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR, URL_AUTHOR, DESCRIPTION);

    server_print(" ")
    server_print("/============ » Discord Reports « ============\")
    server_print("%s Nazwa    : %s", amxxpro_discord[prefix], PLUGIN)
    server_print("%s Wersja   : %s", amxxpro_discord[prefix], VERSION)
    server_print("%s Autor    : N1K1Cz | © AmxxPro.pl", amxxpro_discord[prefix])
    server_print("%s Strona   : © AmxxPro.pl", amxxpro_discord[prefix])
    server_print("%s Opis     : %s", amxxpro_discord[prefix], DESCRIPTION)
    server_print("\=========== » © AmxxPro.PL « ===========/")
    server_print(" ")

    for(new i; i < sizeof repCommands; i ++) register_clcmd(repCommands[i], "MenuOpen");
    StworzArray();
    WczytajPlik();

    //Glowny prefix pluginu ( [» AmxxPro.pl «] - Domyślnie )
    bind_pcvar_string(create_cvar("amxxpro_discord_prefix", "[» AmxxPro.pl «]"), amxxpro_discord[prefix], charsmax(amxxpro_discord[prefix])); 

    //Co ile czasu mozna wysylac zgloszenie? ( 300 - Domyślnie )
    bind_pcvar_num(create_cvar("amxxpro_discord_interval", "300"), amxxpro_discord[interval]); 

    //Jaką flage musi posiadać admin, żeby być wykrywanym jako admin? ( d - Domyślnie )
    bind_pcvar_string(create_cvar("amxxpro_discord_report_flag", "d"), amxxpro_discord[report_flag], charsmax(amxxpro_discord[report_flag])); 

    //Możliwość zgłaszania adminów? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_report_admin", "1"), amxxpro_discord[report_admin]); 

    //Pokazywać # przy adminie w menu zgłoszeń? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_show_admin", "1"), amxxpro_discord[show_admin]); 

    //Pokazywać czas zgłoszenia? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_show_time", "1"), amxxpro_discord[show_time]); 

    //Pokazywać mape zgłoszenia? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_show_map", "1"), amxxpro_discord[show_map]); 

    //Pokazywać powód zgłoszenia? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_show_reason", "1"), amxxpro_discord[show_reason]); 

    //Czy ma być włączony własny powód zgłoszenia? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_my_reason", "1"), amxxpro_discord[my_reason]); 

    //Pokazywać gracza, który zgłosił? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_show_player", "1"), amxxpro_discord[show_player]);   

    //Powiadamiać adminów o zgłoszeniu na czacie? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_show_ping", "1"), amxxpro_discord[show_ping]);  

    //Pokazywać grafikę nad footerem? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_show_footer_img", "1"), amxxpro_discord[show_footer_img]);  

    //Pokazywać grafikę thumbnail? ( 1 - Tak | 0 - Nie )
    bind_pcvar_num(create_cvar("amxxpro_discord_show_thumbnail_img", "1"), amxxpro_discord[show_thumbnail_img]);  

    //ID Grup, które mają zostać oznaczone? ( @everyone - domyslnie )
    bind_pcvar_string(create_cvar("amxxpro_discord_id_ranga", "@everyone"), amxxpro_discord[id_ranga], charsmax(amxxpro_discord[id_ranga]));  

    //Nazwa BOT'a
    bind_pcvar_string(create_cvar("amxxpro_discord_bot_name", "AmxxPro.pl - Report Player"), amxxpro_discord[bot_name], charsmax(amxxpro_discord[bot_name]))

    //Avatar BOT'a
    bind_pcvar_string(create_cvar("amxxpro_discord_bot_avatar", "https://i.imgur.com/TPIL8dC.png"), amxxpro_discord[bot_avatar], charsmax(amxxpro_discord[bot_avatar]))

    //Tytuł BOT'a 
    bind_pcvar_string(create_cvar("amxxpro_discord_bot_title", "ReportBot - AmxxPro.PL"), amxxpro_discord[title], charsmax(amxxpro_discord[title]))

    //Grafika nad footerem 
    bind_pcvar_string(create_cvar("amxxpro_discord_footer_img", "https://i.imgur.com/xVuKyPn.png"), amxxpro_discord[footer_img], charsmax(amxxpro_discord[footer_img]));  

    //Kolor EMBED ( d4af37 - domyslnie)
    bind_pcvar_string(create_cvar("amxxpro_discord_color", "d4af37"), amxxpro_discord[color], charsmax(amxxpro_discord[color]))

    //Grafika thumbnail
    bind_pcvar_string(create_cvar("amxxpro_discord_thumbnail_img", "https://i.imgur.com/TPIL8dC.png"), amxxpro_discord[thumbnail_img], charsmax(amxxpro_discord[thumbnail_img]));  

    set_task(45.0, "ShowInfos", _, _, _, "b");

    create_reasons();
    AntiF = TrieCreate();
}

public plugin_end() TrieDestroy(AntiF);

public create_reasons()
{
        rMenu = menu_create("\d© AmxxPro.pl | Discord Reports^n\w[\r>\w] Wybierz powod:", "handler_reason");
    
        new gReason_n[64];

        if(amxxpro_discord[my_reason]==1)
        {
        register_clcmd("disc_rep_reason", "get_reason");
        menu_additem(rMenu, "\w[\r>\w] Wlasny powod");
        }

        for(new i = 0; i < ArraySize(Powod); i++){
            ArrayGetString(Powod, i, gReason_n, charsmax(gReason_n));
            menu_additem(rMenu, fmt("\w[\r>\w] %s", gReason_n));
        } 
        
        menu_setprop(rMenu, MPROP_NEXTNAME, "\w| \y>>> \w|");
        menu_setprop(rMenu, MPROP_BACKNAME, "\w| \y<<< \w|");
        menu_setprop(rMenu, MPROP_EXITNAME, "\w[\rX\w]");
}
public get_reason(id){
        if(amxxpro_discord[my_reason]==1)
        {
        if(!gTarget[id])
            return;
    
        read_argv(1, gReason[id], charsmax(gReason[]));
        Summary(id);
        }
}
public ShowInfos()
{
    for(new i = 1; i <= 32; i++) 
    {
        if(!is_user_connected(i)) continue;
        ColorChat(i, RED, "^x04%s^x01 Brak adminow na serwerze a gra cheater?", amxxpro_discord[prefix]);
        ColorChat(i, RED, "^x04%s^x01 Uzyj komendy^x03 /zglos^x01 aby wezwac admina!", amxxpro_discord[prefix]);
        ColorChat(i, RED, "^x04%s^x01 Wezwanie admina poniewaz ktos dobrze gra grozi banem!", amxxpro_discord[prefix]);
    }
}
public client_putinserver(id){
    clear(id);
    
    get_user_authid(id, buffer[STEAMID], sizeof buffer[]);
    if(!TrieGetCell(AntiF, buffer[STEAMID], AntiFlood[id])) AntiFlood[id] = 0;
}
public clear(id){
    gTarget[id] = 0;
    gReason[id][0] = '^0';
}

public MenuOpen(id){
    clear(id);
    
    new menu = menu_create("\d© AmxxPro.pl | Discord Reports^n\w[\r>\w] Zglos gracza:", "handler_players");
    
    new pl[32], cnt;
    get_players(pl, cnt, "ch");
    
    for(new i, player; i < cnt; i ++){
        player = pl[i];
        
        if(player == id) continue;

        if(amxxpro_discord[report_admin]==1)
        {
            if(get_user_flags(player) & read_flags(amxxpro_discord[report_flag]) && amxxpro_discord[show_admin]==1) menu_additem(menu, fmt("%n \d[\r#\d]", player), fmt("%d \d[\r#\d]", player));
            else menu_additem(menu, fmt("%n", player), fmt("%d", player));
        }
        else
        {
            if(get_user_flags(player) & read_flags(amxxpro_discord[report_flag])) continue;

            menu_additem(menu, fmt("%n", player), fmt("%d", player));
        }
    }
    
    if(!menu_items(menu)){
        ColorChat(id, GREEN, "^x03%s^x01 Nie jest dostepny zaden gracz do zgloszenia", amxxpro_discord[prefix]);
        menu_destroy(menu);
        return;
    }
    
    menu_setprop(menu, MPROP_NEXTNAME, "\w| \y>>> \w|");
    menu_setprop(menu, MPROP_BACKNAME, "\w| \y<<< \w|");
    menu_setprop(menu, MPROP_EXITNAME, "\w[\rX\w]");
    
    menu_display(id, menu);
}

public handler_players(id, menu, item){
    if(item == MENU_EXIT){
        menu_destroy(menu);
        return;
    }
    
    new systime;
    if(AntiFlood[id] > (systime = get_systime())){
        ColorChat(id, GREEN, "^x03%s^x01 Nastepne zgloszenie mozesz wyslac za^x03 %d sekund", amxxpro_discord[prefix], AntiFlood[id] - systime);
        menu_destroy(menu);
        return;
    }
    
    new access, name[32], info[10], clbck;
    menu_item_getinfo(menu, item, access, info, charsmax(info), name, charsmax(name), clbck);
    menu_destroy(menu);
    
    new pl = str_to_num(info);
    if(!check_target(id, pl)){
        MenuOpen(id);
        return;
    }
    
    gTarget[id] = pl;
    menu_display(id, rMenu);
}

public handler_reason(id, menu, item){
        if(item == MENU_EXIT) return;
        new data[1][64];
        if(amxxpro_discord[my_reason]==1 && item>0) ArrayGetString(Powod, item-1, data[0], charsmax(data[]));
    else ArrayGetString(Powod, item, data[0], charsmax(data[]));
        if(amxxpro_discord[my_reason]==1 && item == 0){
            client_cmd(id, "messagemode disc_rep_reason");
            return;
        }
        copy(gReason[id], charsmax(gReason[]), data[0]);
        Summary(id);
}
public check_target(id, pl){
    if(!is_user_connected(pl)){
        ColorChat(id, GREEN, "^x03%s^x01 Gracz, ktorego chcesz zglosic opuścił serwer!", amxxpro_discord[prefix]);
        clear(id);
        return false;
    }
    return true;
}

public Summary(id)
{
    get_user_name(id, buffer[NAMEID], sizeof buffer[]);
    get_user_name(gTarget[id], buffer[NAMETARGET], sizeof buffer[]);

    new pl[32], cnt;
    get_players(pl, cnt, "ch");

    if(amxxpro_discord[show_ping])
    {
    for(new i=1; i<=cnt; i++)
    {
        if(!(get_user_flags(i) & read_flags(amxxpro_discord[report_flag]))) continue;

        ColorChat(i, GREEN, "^x03%s^x01 Gracz:^x04 %s^x01 Zglasza gracza:^x03 %s^x01.", amxxpro_discord[prefix], buffer[NAMEID], buffer[NAMETARGET])
        ColorChat(i, GREEN, "^x03%s^x01 Powod:^x04 %s", amxxpro_discord[prefix], gReason[id])
    }
    }
    ColorChat(id, GREEN, "^x03%s^x01 Zgloszenie wyslano^x04 pomyslnie^x01!", amxxpro_discord[prefix])
    send_report(id);
}
public send_report(id)
{
    //=-=-=-=-=-=-=-=-=-= ZMIENNE =-=-=-=-=-=-=-=-=-//

    get_user_authid(id, buffer[STEAMID], sizeof buffer[]);
    get_user_authid(gTarget[id], buffer[STEAMTARGET], sizeof buffer[]);
    get_user_name(id, buffer[NAMEID], sizeof buffer[]);
    get_user_name(gTarget[id], buffer[NAMETARGET], sizeof buffer[]);
    get_user_ip(id, buffer[IPID], sizeof buffer[]);
    get_user_ip(gTarget[id], buffer[IPTARGET], sizeof buffer[]);
    
    get_mapname(mapname, charsmax(mapname))
    get_time("%H:%M:%S",gTime,sizeof(gTime));

    //=-=-=-=-=-=-=-=-=-= ZMIENNE =-=-=-=-=-=-=-=-=-//

    if (Discord_StartMessage())
    {
    Discord_SetStringParam(CONTENT, amxxpro_discord[id_ranga]);
    Discord_SetStringParam(USERNAME, amxxpro_discord[bot_name]); 
    Discord_SetStringParam(AUTHOR_NAME, "AmxxPro.pl");  
    Discord_SetStringParam(AUTHOR_AVATAR, "https://imgur.com/TPIL8dC");
    Discord_SetStringParam(AVATAR_URL, amxxpro_discord[bot_avatar]);  
    if(amxxpro_discord[show_footer_img]) Discord_SetStringParam(EMBED_IMAGE, amxxpro_discord[footer_img]);
    if(amxxpro_discord[show_thumbnail_img]) Discord_SetStringParam(EMBED_THUMB, amxxpro_discord[thumbnail_img]);
    Discord_SetStringParam(AUTHOR_URL, "https://amxxpro.pl");
    Discord_SetStringParam(TITLE_URL, "https://amxxpro.pl");
    Discord_SetStringParam(TITLE, amxxpro_discord[title]);
    Discord_SetStringParam(FOOTER_TEXT, "© AmxxPro.PL"); // NIE RUSZAĆ !!!
    Discord_SetCellParam(COLOR, amxxpro_discord[color]);

    format(buffer[STEAMID], sizeof buffer[], "```SID: %s | IP: %s```", buffer[STEAMID], buffer[IPID]);
    format(buffer[STEAMTARGET], sizeof buffer[], "```SID: %s | IP: %s```", buffer[STEAMTARGET], buffer[IPTARGET]);

    if(amxxpro_discord[show_time]==1) Discord_AddField("**Godzina:**", fmt("```%s```", gTime), true);
    if(amxxpro_discord[show_map]==1) Discord_AddField("**Mapa:**", fmt("```%s```", mapname), true);
    if(amxxpro_discord[show_reason]==1) Discord_AddField("**Powód:**", fmt("```%s```", gReason[id]), true);

    if(amxxpro_discord[show_time] || amxxpro_discord[show_map] || amxxpro_discord[show_reason]) Discord_AddField(" ", " ");

    Discord_AddField(fmt("**Zgłoszony gracz: %s**", buffer[NAMETARGET]), buffer[STEAMTARGET], true);

    if(amxxpro_discord[show_player]==1) 
    {
    Discord_AddField(" ", " ");
    Discord_AddField(fmt("**Zgłoszony przez: %s**", buffer[NAMEID]), buffer[STEAMID], true);
    }

    Discord_SendMessage("report");
    }
    AntiFlood[id] = get_systime() + amxxpro_discord[interval];
}