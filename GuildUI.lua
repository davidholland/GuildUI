-- Main Functions/Code
local _, GuildUI=...
local frame

SLASH_GUILDUI1 = '/guildui';
function SlashCmdList.GUILDUI(msg, editbox)
    if msg == "show" then
        ShowGuildFrame();
    elseif msg == "hide" then
        HideGuildFrame();
    else
        print("GuildUI commands: 'show' or 'hide'");
    end
end

-- TODO: UI Code. Call the stuff in here from Events.lua


function ShowGuildFrame()
    if frame == nil then
        --parent frame 
        frame = CreateFrame("Frame", "MyFrame", UIParent) 
        frame:SetSize(150, 200) 
        frame:SetPoint("CENTER") 
        local texture = frame:CreateTexture() 
        texture:SetAllPoints() 
        texture:SetTexture(1,1,1,1) 
        frame.background = texture 
        
        --scrollframe 
        scrollframe = CreateFrame("ScrollFrame", nil, frame) 
        scrollframe:SetPoint("TOPLEFT", 10, -10) 
        scrollframe:SetPoint("BOTTOMRIGHT", -10, 10) 
        local texture = scrollframe:CreateTexture() 
        texture:SetAllPoints() 
        texture:SetTexture(.5,.5,.5,1) 
        frame.scrollframe = scrollframe 
        
        --scrollbar 
        scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate") 
        scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", 4, -16) 
        scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 4, 16) 
        scrollbar:SetMinMaxValues(1, 200) 
        scrollbar:SetValueStep(1) 
        scrollbar.scrollStep = 1
        scrollbar:SetValue(0) 
        scrollbar:SetWidth(16) 
        scrollbar:SetScript("OnValueChanged", 
        function (self, value) 
        self:GetParent():SetVerticalScroll(value) 
        end) 
        local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
        scrollbg:SetAllPoints(scrollbar) 
        scrollbg:SetTexture(0, 0, 0, 0.4) 
        frame.scrollbar = scrollbar 
        
        --content frame 
        local content = CreateFrame("Frame", nil, scrollframe) 
        content:SetSize(128, 128) 
        local texture = content:CreateTexture() 
        texture:SetAllPoints() 
        texture:SetTexture("Interface\\GLUES\\MainMenu\\Glues-BlizzardLogo") 
        content.texture = texture 
        scrollframe.content = content 
        
        scrollframe:SetScrollChild(content)
    end
end

function HideGuildFrame()
    if frame then
        frame:Hide()
    end
end