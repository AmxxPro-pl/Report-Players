#if defined _amxxpro_discord_included
    #endinput
#endif
#define _amxxpro_discord_included

enum 
{
    USERNAME,
    AVATAR_URL,
    CONTENT,
    COLOR, // Discord_SetCellParam
    TITLE_URL,
    TITLE,
    AUTHOR_NAME,
    AUTHOR_AVATAR,
    AUTHOR_URL,
    FIELDS, // Discord_AddField
    TIMESTAMP, // Discord_SetCellParam
    FOOTER_TEXT,
    FOOTER_IMAGE,
    EMBED_THUMB,
    EMBED_IMAGE
}

/**
 * Starts a new message for webhook.
 * WARNING! If you don't call EndMessage() in one tick with StartMessage(), message automatically has been cancelled!
 *
 * @return  bool
 */
native bool:Discord_StartMessage();

/**
 * Cancels a current Discord Message.
 *
 * @return  void
 */
native Discord_CancelMessage();

/**
 * Ends a message, sending into Discord WebHook.
 *
 * @param   webHook   WebHook name from configuration file.
 *
 * @return  void
 */
native Discord_SendMessage(const webHook[]);

/**
 * Setting string parameters
 *
 * @param   param   Parameter Number (enum)
 * @param   text    Formatted text content
 *
 * @return  void
 */
native Discord_SetStringParam(const param, const text[], ...);

/**
 * Setting numeric parameters
 *
 * @param   param   Parameter Number (enum)
 * @param   value   Numerical value
 *
 * @return  void
 */
native Discord_SetCellParam(const param, const value);

/**
 * Adds a field to an array
 *
 * @param   title   Name
 * @param   value   Text
 * @param   inline if true, fields will be displayed in same line, but there can only be 3 max in same line or 2 max if you used thumbnail
 *
 * @return  void
 */
native Discord_AddField(const title[], const value[], bool:inline = false);

/**
 * Checks for a webhook in the configuration file.
 *
 * @param   webHook   Webhook title
 *
 * @return  bool
 */
native bool:Discord_WebHookExists(const webHook[]);

new const file_api[] = "addons/amxmodx/configs/AmxxProPL/api.cfg";
new const file_cfg[] = "addons/amxmodx/configs/AmxxProPL/discord.cfg";
new const file_ini[] = "addons/amxmodx/configs/AmxxProPL/reasons.ini";
new linia_z_pliku[256], dlugosc_lini;

new Array:Powod;

StworzArray() Powod = ArrayCreate(64, 1);

WczytajPlik(){    
    new lineData[1][64];

    for(new i = 0; read_file(file_ini, i, linia_z_pliku,charsmax(linia_z_pliku), dlugosc_lini); i++){
        if(!linia_z_pliku[0] || !dlugosc_lini || linia_z_pliku[0] == ';')
            continue;

        parse(linia_z_pliku, lineData[0], charsmax(lineData[]));

        ArrayPushString(Powod, lineData[0]);
    }
    return PLUGIN_CONTINUE;
}

public ConfigFileApi(){
    if(file_exists(file_api)){

    server_cmd("exec addons/amxmodx/configs/AmxxProPL/api.cfg");
        
    log_amx("===================== » Discord « =====================")
    log_amx("        Plik ^"%s^" zostal poprawnie wczytany.", file_api);
        
    return PLUGIN_HANDLED;

    }else{
        
    log_amx("===================== » Discord « =====================")
    log_amx("        Plik ^"%s^" zostal poprawnie utworzony.", file_api);
    
    if(!dir_exists("addons/amxmodx/configs/AmxxProPL"))
        mkdir("addons/amxmodx/configs/AmxxProPL");

    if(!file_exists(file_api)){
        write_file(file_api, "//===================== » API - Configuration « =====================", -1);
        write_file(file_api, "//                     Autor: N1K1Cz", -1);
        write_file(file_api, "//                     Strona: © AmxxPro.pl", -1);
        write_file(file_api, "", -1);
        write_file(file_api, "^"Discord^"", -1);
        write_file(file_api, "{", -1);
        write_file(file_api, "^"report^" ^"https://discord.com/api/webhooks/ID^"", -1);
        write_file(file_api, "}", -1);
        write_file(file_api, "", -1);
        write_file(file_api, "//===================== » API - Configuration « =====================", -1);
    }
    server_cmd("exec %s", file_api);
    }
    return PLUGIN_CONTINUE;
}
public ConfigFileCfg(){
    if(file_exists(file_cfg)){

    server_cmd("exec %s", file_cfg);
        
    log_amx("        Plik ^"%s^" zostal poprawnie wczytany.", file_cfg);
        
    return PLUGIN_HANDLED;

    }else{
        
    log_amx("        Plik ^"%s^" zostal poprawnie utworzony.", file_cfg);
    
    if(!dir_exists("addons/amxmodx/configs/AmxxProPL"))
        mkdir("addons/amxmodx/configs/AmxxProPL");

    if(!file_exists(file_cfg)){
        write_file(file_cfg, "//===================== » Discord - Configuration « =====================", -1);
        write_file(file_cfg, "//                     Autor pluginu: N1K1Cz", -1);
        write_file(file_cfg, "//                     Strona: © AmxxPro.pl", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Glowny prefix pluginu ( [» AmxxPro.pl «] - Domyślnie )", -1);
        write_file(file_cfg, "amxxpro_discord_prefix ^"[» AmxxPro.pl «]^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Co ile czasu mozna wysylac zgloszenie? ( 300 - Domyślnie )", -1);
        write_file(file_cfg, "amxxpro_discord_interval ^"300^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Jaką flage musi posiadać admin, żeby być wykrywanym jako admin? ( d - Domyślnie )", -1);
        write_file(file_cfg, "amxxpro_discord_report_flag ^"d^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Możliwość zgłaszania adminów? ( 1 - Tak | 0 - Nie )", -1);
        write_file(file_cfg, "amxxpro_discord_report_admin ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Pokazywać # przy adminie w menu zgłoszeń? ( 1 - Tak | 0 - Nie )", -1);          
        write_file(file_cfg, "amxxpro_discord_show_admin ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Pokazywać czas zgłoszenia? ( 1 - Tak | 0 - Nie )", -1);
        write_file(file_cfg, "amxxpro_discord_show_time ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Pokazywać mape zgłoszenia? ( 1 - Tak | 0 - Nie )", -1);
        write_file(file_cfg, "amxxpro_discord_show_map ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Pokazywać powód zgłoszenia? ( 1 - Tak | 0 - Nie )", -1);
        write_file(file_cfg, "amxxpro_discord_show_reason ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Czy ma być włączony własny powód zgłoszenia? ( 1 - Tak | 0 - Nie )", -1);
        write_file(file_cfg, "amxxpro_discord_my_reason ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Pokazywać gracza, który zgłosił? ( 1 - Tak | 0 - Nie )", -1);
        write_file(file_cfg, "amxxpro_discord_show_player ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Powiadamiać adminów o zgłoszeniu na czacie? ( 1 - Tak | 0 - Nie )", -1);
        write_file(file_cfg, "amxxpro_discord_show_ping ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Pokazywać grafikę nad footerem? ( 1 - Tak | 0 - Nie )", -1);
        write_file(file_cfg, "amxxpro_discord_show_footer_img ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Pokazywać grafikę thumbnail? ( 1 - Tak | 0 - Nie )", -1);
        write_file(file_cfg, "amxxpro_discord_show_thumbnail_img ^"1^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//ID Grup, które mają zostać oznaczone? ( @everyone - domyslnie )", -1);
        write_file(file_cfg, "amxxpro_discord_id_ranga ^"@everyone^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Nazwa BOT'a", -1);
        write_file(file_cfg, "amxxpro_discord_bot_name ^"AmxxPro.pl - Report Player^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Avatar BOT'a", -1);
        write_file(file_cfg, "amxxpro_discord_bot_avatar ^"https://i.imgur.com/TPIL8dC.png^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Tytuł BOT'a", -1);
        write_file(file_cfg, "amxxpro_discord_bot_title ^"ReportBot - AmxxPro.PL^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Grafika nad footerem", -1);
        write_file(file_cfg, "amxxpro_discord_footer_img ^"https://i.imgur.com/XbCYbfe.png^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Kolor EMBED ( d4af37 - domyslnie)", -1);
        write_file(file_cfg, "amxxpro_discord_color ^"d4af37^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//Grafika thumbnail", -1);
        write_file(file_cfg, "amxxpro_discord_thumbnail_img ^"https://i.imgur.com/TPIL8dC.png^"", -1);
        write_file(file_cfg, "", -1);
        write_file(file_cfg, "//===================== » Discord - Configuration « =====================", -1);
     }
        server_cmd("exec %s", file_cfg);
     }

     return PLUGIN_CONTINUE;
}

public ConfigFileIni(){
    if(file_exists(file_ini)){
        
    log_amx("        Plik ^"%s^" zostal poprawnie wczytany.", file_ini);
    log_amx("===================== » Discord « =====================")

    return PLUGIN_HANDLED;

    }else{
        
    log_amx("        Plik ^"%s^" zostal poprawnie utworzony.", file_ini);
    log_amx("===================== » Discord « =====================")
    
    if(!dir_exists("addons/amxmodx/configs/AmxxProPL"))
        mkdir("addons/amxmodx/configs/AmxxProPL");

    if(!file_exists(file_ini)){
        write_file(file_ini, ";===================== » Reasons - Configuration « =====================", -1);
        write_file(file_ini, ";                     Autor: N1K1Cz", -1);
        write_file(file_ini, ";                     Strona: © AmxxPro.pl", -1);
        write_file(file_ini, "", -1);
        write_file(file_ini, "Cheater", -1);
        write_file(file_ini, "Wyzywa", -1);
        write_file(file_ini, "Naduzywa Mikro", -1);
        write_file(file_ini, "Nie wykonuje cel mapy", -1);
        write_file(file_ini, "", -1);
        write_file(file_ini, ";===================== » Reasons - Configuration « =====================", -1);
    }
        WczytajPlik()
    }
    return PLUGIN_CONTINUE;
}