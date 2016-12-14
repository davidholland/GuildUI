-- Home for event handlers
local _, GuildUI=...

local function GuildRosterUpdated(...) {
    local wasUpdated = ...
    print("Guild roster was updated.")

    -- local totalCount, onlineCount, mobileCount = GetNumGuildMembers()
    -- for index in totalCount do
    --     local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(index)
    -- end
}

local function SystemMessageReceived(...) {
    local message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter = ...
    print("System chat message was received.")
}

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