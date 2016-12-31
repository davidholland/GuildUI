-- Global-object, enum and type definitions
local _, GuildUI_Local=...

GuildUI = {}
GuildUI.LoggingEnabled = false
GuildUI.GuildName = ""
GuildUI.GuildRankName = ""
GuildUI.GuildRankIndex = 0 
GuildUI.PlayerCount = 0 -- Total player count
GuildUI.OnlineCount = 0 -- Online player count
GuildUI.MobileCount = 0 -- Armory-app signed-in players
GuildUI.Players = {} -- roster
