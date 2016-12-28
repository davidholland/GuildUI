-- Home for event handlers
local _, GuildUI=...

local function OnLoad(...)
    GuildUI.Log("Player loaded.")
    GuildUI.GuildName, GuildUI.GuildRankName, GuildUI.GuildRankIndex = GetGuildInfo("player")
end

local function GuildRosterUpdated(...)
    local wasUpdated = ...
    GuildUI.Log("Guild roster was updated.")

    GuildUI.PlayerCount, GuildUI.OnlineCount, GuildUI.MobileCount = GetNumGuildMembers()
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
        GuildUI.Players[player.FullName] = player
    end
end

local function SystemMessageReceived(...)
    local message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter = ...
    GuildUI.Log("System chat message was received.")
end

-- define event->handler mapping
local eventHandlers = {
    GUILD_ROSTER_UPDATE = GuildRosterUpdated,
    CHAT_MSG_SYSTEN = SystemMessageReceived,
    PLAYER_ENTERING_WORLD = onLoad
}

-- create dummy frame for wiring up events
local frame = CreateFrame("Frame")

-- associate event handlers to desired events
for key,block in pairs(eventHandlers) do frame:RegisterEvent(key) end
frame:SetScript('OnEvent', 
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

-- frame:SetScript("OnUpdate", OnUpdate)

GuildUI.Log("Events loaded.")