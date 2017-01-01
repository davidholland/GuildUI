-- Home for event handlers
local _, GuildUI_Local=...

-- Slash commands
SLASH_GUILDUI1 = '/guildui';
function SlashCmdList.GUILDUI(msg, editbox)
    if msg == "show" then
        GuildUI_Frame:Show();
    elseif msg == "hide" then
        GuildUI_Frame:Hide();
    elseif msg == "reset" then
        GuildUI_ResetSizeAndPosition();
    elseif msg == "logging on" then
        GuildUI.LoggingEnabled = true
        print("GuildUI: Logging enabled")
    elseif msg == "logging off" then
        GuildUI.LoggingEnabled = false
        print("GuildUI: Logging disabled.")
    else
        print("GuildUI commands:"); 
        print(" - 'show': Shows the guild info window.");
        print(" - 'hide': Hides the guild info window.");
        print(" - 'reset': Resets the window position.");
        print(" - 'logging (on|off)': Toggles logging");
    end
end

-- Event handlers
local function OnPlayerLoad(...)
    GuildUI.Log("Player loaded.")
    GuildUI.GuildName, GuildUI.GuildRankName, GuildUI.GuildRankIndex = GetGuildInfo("player")
end

local function OnLoad(...)
    local addon = ...
    if addon ~= "GuildUI" then return end

    GuildUI = GuildUI_DB or {}
    GuildUI.Log = function (...)
        if GuildUI.LoggingEnabled then
            print("GuildUI:", ...)
        end
    end

    GuildUI.Log("Addon loaded.")
end

local function OnUnload(...)
    GuildUI_DB = GuildUI or {}
end

local function GuildRosterUpdated(...)
    local wasUpdated = ...

    GuildUI.PlayerCount, GuildUI.OnlineCount, GuildUI.MobileCount = GetNumGuildMembers()
    local updateCount = 0
    local updatedPlayers = {}
    for index=1,GuildUI.PlayerCount do
        local fullName, rank, rankIndex, level, class, zone, note, officerNote, isOnline, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(index)        
        local name, server = string.match(fullName, "(%a)%-(%a)")
        local player = {
            Name = name,
            Server = server,
            FullName = fullName,
            Rank = Rank,
            RankIndex = rankIndex,
            Level = level,
            Class = class,
            Zone = zone,
            Note = note,
            OfficerNote = officerNote,
            IsOnline = isOnline,
            Status = status,
            ClassFileName = ClassFileName,
            AchievementPoints = achievementPoints,
            AchievementRank = achievementRank,
            IsMobile = isMobile,
            Reputation = reputation
        }
        updatedPlayers[player.FullName] = player
        updateCount = updateCount + 1
    end

    -- Check for and remove quitters
    local removedPlayers = 0
    for existingPlayerName, _ in pairs(GuildUI.Players) do
        local isFound = false
        for updatedPlayerName, _ in pairs(updatedPlayers) do
            if updatedPlayerName == existingPlayerName then
                isFound = true
                break
            end
        end

        if isFound == false then
            removedPlayers = removedPlayers + 1
            GuildUI.Players[existingPlayerName] = nil
        end
    end
    if removedPlayers > 0 then GuildUI.Log(removedPlayers .. " players removed.") end

    -- Merge tables
    for updatedPlayerName, updatedPlayer in pairs(updatedPlayers) do
    end
    
    --Update UI elements
    GuildUI_UpdateMemberCount()
    --TODO: Re-populate table data

    SetSmallGuildTabardTextures("player", LibDBIcon10_GuildUI_Icon)
    
    GuildUI.Log("Guild roster was updated. (" .. updateCount .. " records)")
end

local function SystemMessageReceived(...)
    local message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter = ...
    GuildUI.Log("System chat message was received.")
end

-- define event->handler mapping
local eventHandlers = {
    GUILD_ROSTER_UPDATE = GuildRosterUpdated,
    CHAT_MSG_SYSTEN = SystemMessageReceived,
    PLAYER_ENTERING_WORLD = OnPlayerLoad,
    ADDON_LOADED = OnLoad,
    PLAYER_LOGOUT = OnUnload
}

-- associate event handlers to desired events
for key,block in pairs(eventHandlers) do GuildUI_Frame:RegisterEvent(key) end
GuildUI_Frame:SetScript('OnEvent', 
    function(self, event, ...)
        for key,block in pairs(eventHandlers) do
            if event == key then
                block(...)
            end
        end
    end
)

--Continuous update handler

-- local updateInterval = 5
-- local totalElapsed = 0
-- local function OnUpdate(self,elapsed)
--     totalElapsed = totalElapsed + elapsed
--     if totalElapsed >= updateInterval then
--         totalElapsed = 0
--         GuildUI.Log("Process code on interval ", updateInterval)
--     end
-- end

-- GuildUI_Frame:SetScript("OnUpdate", OnUpdate)