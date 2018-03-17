/*  CS:GO Multi1v1: He grenade battle round addon
 *
 *  Copyright (C) 2018 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */
 
 
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <multi1v1>

#pragma semicolon 1
#pragma newdecls required

int g_iRoundType;

public Plugin myinfo = {
  name = "CS:GO Multi1v1: He grenade battle round addon",
  author = "Franc1sco franug",
  description = "Adds an unranked He grenade battle round-type",
  version = "1.0.0",
  url = "http://steamcommunity.com/id/franug"
};

public void Multi1v1_OnRoundTypesAdded() 
{
	// Add the custom round and get custom round index
	g_iRoundType = Multi1v1_AddRoundType("He Grenade battle", "hegrenade", DodgeballHandler, true, false, "", true);
	
	// Hook grenade detonate event
	HookEvent("hegrenade_detonate", Event_Detonate);
}

public void DodgeballHandler(int iClient) 
{
	// Start the custom round with a he grenade
	GivePlayerItem(iClient, "weapon_hegrenade");
	SetEntityHealth(iClient, 100);
	
	// Remove armor (Thanks to Wacci)
	SetEntProp(iClient, Prop_Data, "m_ArmorValue", 0);
}

public Action Event_Detonate(Handle event, const char[] eventname, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));

	// checkers on the client index for prevent errors
	if (iClient == -1 || !IsClientInGame(iClient) || !IsPlayerAlive(iClient))
		return;
		
	// If current round is decoy round then do timer
	if(Multi1v1_GetCurrentRoundType(Multi1v1_GetArenaNumber(iClient)) == g_iRoundType)
		GivePlayerItem(iClient, "weapon_hegrenade"); // Give new hegrenade
}