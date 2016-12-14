-- Home for event handlers
local _, GuildUI=...

local function GuildRosterUpdated(...)
    local wasUpdated = ...
    print("Guild roster was updated.")

    if not GuildUI.Players then
        GuildUI.Players = {}
    end

    GuildUI.PlayerCount, GuildUI.OnlineCount, GuildUI.MobileCount = GetNumGuildMembers()
    for index=0,GuildUI.PlayerCount do
        local fullName, rank, rankIndex, level, class, zone, note, officerNote, isOnline, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(index)
        local player = {
            Name = fullName, --TODO: Regex parse the first part
            FullName = fullName,
            Rank = Rank,
            RankIndex = rankIndex,
            Level = level,
            Class = class,
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
        table.insert(GuildUI.Players, player)
    end
end

local function SystemMessageReceived(...)
    local message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter = ...
    print("System chat message was received.")
end

-- define event->handler mapping
local eventHandlers = {
    GUILD_ROSTER_UPDATE = GuildRosterUpdated,
    CHAT_MSG_SYSTEN = SystemMessageReceived
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
--         print("Process code on interval ", updateInterval)
--     end
-- end

-- frame:SetScript("OnUpdate", OnUpdate)

print("Events loaded.")