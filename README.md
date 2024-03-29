<div align="center">
<h1><p></p>Report Players<p></p></h1>
<img src="https://github.com/AmxxPro-pl/.github/blob/main/banner-new-2.png"></img>
</div>

---

### Description
- System zgłoszeń graczy CS 1.6 zintegrowany z platformą Discord
- Odczytywanie powodów z pliku reasons.ini
- Odczytywanie cvarów z pliku discord.cfg

</div>

### Configure
<details>
  <summary><b>api.cfg</b></summary>

```
//===================== » API - Configuration « =====================
//                     Autor: N1K1Cz
//                     Strona: © AmxxPro.pl

"Discord"
{
"report" "https://discord.com/api/webhooks/ID"
}

//===================== » API - Configuration « =====================
```
</details>

<details>
  <summary><b>discord.cfg</b></summary>

```
//===================== » Discord - Configuration « =====================
//                     Autor pluginu: N1K1Cz
//                     Strona: © AmxxPro.pl

//Glowny prefix pluginu ( [» AmxxPro.pl «] - Domyślnie )
amxxpro_discord_prefix "[» AmxxPro.pl «]"

//Co ile czasu mozna wysylac zgloszenie? ( 300 - Domyślnie )
amxxpro_discord_interval "300"

//Jaką flage musi posiadać admin, żeby być wykrywanym jako admin? ( d - Domyślnie )
amxxpro_discord_report_flag "d"

//Możliwość zgłaszania adminów? ( 1 - Tak | 0 - Nie )
amxxpro_discord_report_admin "1"

//Pokazywać # przy adminie w menu zgłoszeń? ( 1 - Tak | 0 - Nie )
amxxpro_discord_show_admin "1"

//Pokazywać czas zgłoszenia? ( 1 - Tak | 0 - Nie )
amxxpro_discord_show_time "1"

//Pokazywać mape zgłoszenia? ( 1 - Tak | 0 - Nie )
amxxpro_discord_show_map "1"

//Pokazywać powód zgłoszenia? ( 1 - Tak | 0 - Nie )
amxxpro_discord_show_reason "1"

//Czy ma być włączony własny powód zgłoszenia? ( 1 - Tak | 0 - Nie )
amxxpro_discord_my_reason "1"

//Pokazywać gracza, który zgłosił? ( 1 - Tak | 0 - Nie )
amxxpro_discord_show_player "1"

//Powiadamiać adminów o zgłoszeniu na czacie? ( 1 - Tak | 0 - Nie )
amxxpro_discord_show_ping "1"

//Pokazywać grafikę nad footerem? ( 1 - Tak | 0 - Nie )
amxxpro_discord_show_footer_img "1"

//Pokazywać grafikę thumbnail? ( 1 - Tak | 0 - Nie )
amxxpro_discord_show_thumbnail_img "1"

//ID Grup, które mają zostać oznaczone? ( @everyone - domyslnie )
amxxpro_discord_id_ranga "@everyone"

//Nazwa BOT'a
amxxpro_discord_bot_name "AmxxPro.pl - Report Player"

//Avatar BOT'a
amxxpro_discord_bot_avatar "https://i.imgur.com/EDUv58r.png"

//Tytuł BOT'a
amxxpro_discord_bot_title "ReportBot - AmxxPro.PL"

//Grafika nad footerem
amxxpro_discord_footer_img "https://i.imgur.com/nlCnT4I.png"

//Kolor EMBED ( 12092939 - domyslnie)
amxxpro_discord_color "12092939"

//Grafika thumbnail
amxxpro_discord_thumbnail_img "https://i.imgur.com/EDUv58r.png"

//===================== » Discord - Configuration « =====================
```
</details>

<details>
  <summary><b>reasons.ini</b></summary>

```
;===================== » Reasons - Configuration « =====================
;                     Autor: N1K1Cz
;                     Strona: © AmxxPro.pl

"Cheater"
"Wyzywa"
"Naduzywa Mikro"
"Nie wykonuje cel mapy"

;===================== » Reasons - Configuration « =====================
```
</details>

<details>
  <summary><b>Instrukcja Instalacji</b></summary>

```
1. Pobierasz całość jako folder ZIP i rozpakowujesz
2. Do kompilatora wrzucasz bezpośrednio plik .sma oraz pliki .inc do foleru include kompilatora (łącznie te z folderu z grip)
3. Na serwer musisz wrzucić przekompilowany plik .amxx do plugins oraz cała zawartość folderu configs oraz modules do odpowiednich folerów
4. Po odpaleniu serwera utworzą Ci się w configs pliki - najważniejszy to api.cfg do którego podajesz link do utworzonego na serwerze discord webhooka
```
</details>

### ScreenShots

<details>
  <summary><b>Server</b></summary>
  
  - Chat
  
  <img src="https://github.com/AmxxPro-pl/Report-Players/blob/main/img/chat.png"></img>
  - Interval Time
  
  <img src="https://github.com/AmxxPro-pl/Report-Players/blob/main/img/time.png"></img>
  - Menu Players
  
  <img src="https://github.com/AmxxPro-pl/Report-Players/blob/main/img/players.png"></img>
  - Menu Reasons
  
  <img src="https://github.com/AmxxPro-pl/Report-Players/blob/main/img/reasons.png"></img>
</details>
<details>
  <summary><b>Discord</b></summary>
  
  - Discord Message
  
  <img src="https://github.com/AmxxPro-pl/Report-Players/blob/main/img/F8C093D3-3F56-4B5C-B79C-3875E92E14AF.jpeg"></img>
</details>

### Requirements 
- AMXModX 1.9 / AMXModX 1.10
- ReHLDS
- GRIP 0.1.3 +
