#include <sourcemod>
#include <discord>
#include <SteamWorks>
#pragma semicolon 1
#pragma newdecls required
#define WEBHOOK "webhooku giriniz"
char renkler[12][256];
bool bekleme = false, adminvar = false, yetkilicagirildi = false;
public Plugin myinfo =  { name = "", author = "phiso", description = "", version = "1.0", url = "phiso#3331" };
public void OnPluginStart()
{
	RegConsoleCmd("sm_yetkilicagir", yetkilicagir);
}
void RandomRenk() { renkler[0] = "#7fff00"; renkler[1] = "#ffd700"; renkler[3] = "#b22222"; renkler[2] = "#cd5c5c"; renkler[4] = "#ff69b4"; renkler[5] = "#EEDD82"; renkler[6] = "#00cdcd"; renkler[7] = "#FF8247"; renkler[8] = "#000000"; renkler[9] = "#CD9B1D"; renkler[10] = "#0000CD"; renkler[11] = "#eee8aa"; }
public Action yetkilicagir(int client, int args)
{
	if (args)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && !IsFakeClient(i))
			{
				if ((GetAdminFlag(GetUserAdmin(i), Admin_Generic)))
				{
					adminvar = true;
				}
				else
				{
					adminvar = false;
				}
			}
		}
		if (!bekleme)
		{
			if (!adminvar)
			{
				bekleme = true;
				yetkilicagirildi = true;
				CreateTimer(120.0, BeklemeKaldir, _, TIMER_FLAG_NO_MAPCHANGE);
				PrintToChat(client, "[SM] \x04Yetkiliyi çağırdın!");
				char sConnect[31], map[128], steamid[128], string[128], sIP[32], steamid64[32], name[32], steamlink[128], isimlink[128];
				GetCurrentMap(map, sizeof(map));
				GetCmdArgString(string, sizeof(string));
				GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
				RandomRenk();
				int randomrenk = GetRandomInt(0, 11);
				int pic[4];
				SteamWorks_GetPublicIP(pic);
				Format(sIP, sizeof(sIP), "%d.%d.%d.%d", pic[0], pic[1], pic[2], pic[3]);
				Format(sConnect, sizeof(sConnect), "steam://connect/%s", sIP);
				GetClientAuthId(client, AuthId_SteamID64, steamid64, sizeof(steamid64));
				GetClientName(client, name, sizeof(name));
				Format(steamlink, sizeof(steamlink), "http://steamcommunity.com/profiles/%s", steamid64);
				Format(isimlink, sizeof(isimlink), "[%s](%s) isimli oyuncu yetkili çağırıyor! ", name, steamlink);
				DiscordWebHook hook = new DiscordWebHook(WEBHOOK);
				hook.SlackMode = true;
				hook.SetUsername("Yetkili Çağırıldı!");
				MessageEmbed Embed = new MessageEmbed();
				Embed.SetTitle("★ Yetkili Çağırıldı ★");
				Embed.SetTitleLink("https://pluginmerkezi.com");
				Embed.SetColor(renkler[randomrenk]);
				Embed.AddField("Yetkiliyi Çağıran:", isimlink, true);
				Embed.AddField("Steam ID:", steamid);
				Embed.AddField("Çağırma sebebi:", string);
				Embed.AddField("Harita:", map);
				Embed.AddField("Sunucuya Bağlan:", sConnect);
				Embed.SetThumb("https://cdn.discordapp.com/attachments/767041426126798868/772869291207950336/d82a2d1bc3f3e0bc834161404f421ef7.webp");
				Embed.SetFooter("oyunhosttan sunucu alın bb!");
				Embed.SetFooterIcon("https://cdn.discordapp.com/attachments/767041426126798868/772869291207950336/d82a2d1bc3f3e0bc834161404f421ef7.webp");
				hook.Embed(Embed);
				hook.Send();
				delete hook;
			}
			else
			{
				ReplyToCommand(client, "[SM] \x04Şuanda bi admin var!");
				return Plugin_Handled;
			}
		}
		else
		{
			ReplyToCommand(client, "[SM] \x04Bekleme süresinin bitmesini bekle.");
			return Plugin_Handled;
		}
	}
	else
	{
		ReplyToCommand(client, "[SM] \x02Kullanım: \x04!yetkilicagir <sebep>");
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
public Action BeklemeKaldir(Handle Timer) { bekleme = false; }
public void OnClientPostAdminCheck(int client)
{
	if (yetkilicagirildi)
	{
		if ((GetAdminFlag(GetUserAdmin(client), Admin_Generic)) && IsClientValid(client))
		{
			char steamid[32], map[34], sIP[32], sConnect[128], steamid64[32], name[32], steamlink[128], isimlink[128];
			GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
			GetCurrentMap(map, sizeof(map));
			int pic[4];
			SteamWorks_GetPublicIP(pic);
			Format(sIP, sizeof(sIP), "%d.%d.%d.%d", pic[0], pic[1], pic[2], pic[3]);
			RandomRenk();
			int randomrenk = GetRandomInt(0, 11);
			Format(sConnect, sizeof(sConnect), "steam://connect/%s", sIP);
			GetClientAuthId(client, AuthId_SteamID64, steamid64, sizeof(steamid64));
			GetClientName(client, name, sizeof(name));
			Format(steamlink, sizeof(steamlink), "http://steamcommunity.com/profiles/%s", steamid64);
			Format(isimlink, sizeof(isimlink), "[%s](%s) isimli yetkili sunucuya girdi! ", name, steamlink);
			
			DiscordWebHook hook = new DiscordWebHook(WEBHOOK);
			hook.SlackMode = true;
			hook.SetUsername("Yetkili Girdi!");
			
			MessageEmbed Embed2 = new MessageEmbed();
			
			Embed2.SetTitle("★ Sunucuya yetkili girdi! ★");
			Embed2.SetTitleLink("https://forum.pluginmerkezi.com/d/18-plugin-paketi");
			Embed2.SetColor(renkler[randomrenk]);
			Embed2.AddField("Giren Yetkili:", isimlink, true);
			Embed2.AddField("Steam ID:", steamid, false);
			Embed2.AddField("Harita:", map, false);
			Embed2.AddField("Sunucuya Bağlan:", sConnect, true);
			Embed2.SetThumb("https://cdn.discordapp.com/attachments/767041426126798868/772869291207950336/d82a2d1bc3f3e0bc834161404f421ef7.webp");
			Embed2.SetFooter("oyunhosttan sunucu alın bb!");
			Embed2.SetFooterIcon("https://cdn.discordapp.com/attachments/767041426126798868/772869291207950336/d82a2d1bc3f3e0bc834161404f421ef7.webp");
			hook.Embed(Embed2);
			hook.Send();
			delete hook;
			yetkilicagirildi = false;
		}
	}
}
bool IsClientValid(int client)
{
	if (client > 0 && client <= MaxClients)
	{
		if (IsClientInGame(client) && !IsClientSourceTV(client) && !IsFakeClient(client))
		{
			return true;
		}
	}
	return false;
} 