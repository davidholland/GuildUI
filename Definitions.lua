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
MinimapPositionition = 45 -- minimap icon location


-- Configure minimap icon

local tempFrame = CreateFrame("Frame", "GuildUI_MinimapDummy", UIParent)

local aceAddon = LibStub("AceAddon-3.0"):NewAddon("GuildUI", "AceConsole-3.0")
local GuildUI_Icon = LibStub("LibDataBroker-1.1"):NewDataObject("GuildUI_DB", {
	type = "data source",
	text = "GuildUI",
	icon = "", --set this to nothing. we'll override it later
    OnClick = function() GuildUI_ToggleFrame(); end,
})
local libDBIcon = LibStub("LibDBIcon-1.0")

function aceAddon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GuildUI_AceDB", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	})
	libDBIcon:Register("GuildUI", GuildUI_Icon, self.db.profile.minimap)    
end