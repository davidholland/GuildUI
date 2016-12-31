-- Main Functions/Code
local _, GuildUI_Local=...

function GuildUI_InitFrame()
    local guildName, rankName, rankIndex = GetGuildInfo("player")
    GuildUI_Frame_GuildName:SetText(guildName)
    GuildUI_UpdateMemberCount()
end

function GuildUI_ResetSizeAndPosition()
    GuildUI_Frame:ClearAllPoints()
    GuildUI_Frame:SetPoint("CENTER", 0, 0);
    GuildUI_Frame:SetSize(800, 500);
    GuildUI.Log("Main frame position reset.")
end

function GuildUI_UpdateMemberCount()
    GuildUI_Frame_MembersCountLabel:SetText(GuildUI.OnlineCount .. "/" .. GuildUI.PlayerCount)
end