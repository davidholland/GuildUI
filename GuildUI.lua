-- Main Functions/Code
local _, GuildUI_Local=...

local ColumnTypes = { Text = "Text", Icon = "Icon", IconList = "IconList" }

local ColumnDefinitions = {
    { Title = "LEVEL_ABBR", PropertyName = "Level", Type = ColumnTypes.Text, Align = "RIGHT", Width = 35, Hidden = false },
    { Title = "CLASS_ABBR", PropertyName = "ClassFileName", Type = ColumnTypes.Icon, Align = "LEFT", Width = 35, Hidden = false },
    { Title = "NAME", PropertyName = "Name", Type = ColumnTypes.Text, Align = "LEFT", Width = 100, Hidden = false },
    { Title = "ZONE", PropertyName = "Zone", Type = ColumnTypes.Text, Align = "LEFT", Width = 130, Hidden = false },
    { Title = "LASTONLINE", PropertyName = "LastOnline", Type = ColumnTypes.Text, Align = "LEFT", Width = 80, Hidden = false },
    { Title = "RANK", PropertyName = "Rank", Type = ColumnTypes.Text, Align = "LEFT", Width = 80, Hidden = false },
    { Title = "REPUTATION", PropertyName = "Reputation", Type = ColumnTypes.Text, Align = "LEFT", Width = 135, Hidden = false },
    { Title = "LABEL_NOTE", PropertyName = "Note", Type = ColumnTypes.Text, Align = "LEFT", Width = 150, Hidden = false },
    { Title = "OFFICER_NOTE_COLON", PropertyName = "Officer Note", Type = ColumnTypes.Text, Align = "LEFT", Width = 150, Hidden = false },
    { Title = "ACHIEVEMENT_POINTS", PropertyName = "AchievementPoints", Type = ColumnTypes.Text, Align = "RIGHT", Width = 85, Hidden = false },
    { Title = "BG_RATING_ABBR", PropertyName = "BGRating", Type = ColumnTypes.Text, Align = "RIGHT", Width = 55, Hidden = true },
    { Title = "ARENA_RATING", PropertyName = "ArenaRating", Type = ColumnTypes.Text, Align = "RIGHT", Width = 90, Hidden = true },
    { Title = "SKILL_POINTS_ABBR", PropertyName = "SkillIcons", Type = ColumnTypes.IconList, Align = "LEFT", Width = 35, Hidden = true }
}

function GuildUI_InitFrame()
    local guildName, rankName, rankIndex = GetGuildInfo("player")
    GuildUI_Frame_GuildName:SetText(guildName)
    GuildUI_UpdateMemberCount()
    GuildUI_Frame:SetMinResize(1075, 500)

    GuildUI_InitColumns()
    GuildUI_PopulateRows()
end

function GuildUI_ResetSizeAndPosition()
    GuildUI_Frame:ClearAllPoints()
    GuildUI_Frame:SetPoint("CENTER", 0, 0);
    GuildUI_Frame:SetSize(1075, 500);
    GuildUI.Log("Main frame position reset.")
end

function GuildUI_UpdateMemberCount()
    GuildUI_Frame_MembersCountLabel:SetText(GuildUI.OnlineCount .. "/" .. GuildUI.PlayerCount)
end

function GuildUI_ToggleFrame()
    if GuildUI_Frame:IsVisible() then
        GuildUI_Frame:Hide();
    else
        GuildUI_Frame:Show();
    end
end

function GuildUI_InitColumns()
    local columnCount = 0
    local columns = {}

    --create and anchor columns by definition
    for i, columnDefinition in ipairs(ColumnDefinitions) do
        if not columnDefinition.Hidden then
            local columnButton = CreateFrame("Button", "GuildUI_Column_" .. (columnCount + 1), GuildUI_Frame_Columns, "GuildUI_ColumnTemplate")
            columnButton:SetText(GetText(columnDefinition.Title))
            columnButton:SetWidth(columnDefinition.Width)

            --anchor columns to each other (or to the top-right of the parent, if it's the first column)
            if columnCount > 0 then
                local lastColumn = columns[columnCount]
                columnButton:SetPoint("LEFT", lastColumn, "RIGHT", -1, 0)
            else
                columnButton:SetPoint("TOPLEFT")
            end

            table.insert(columns, columnButton)
            columnCount = columnCount + 1
        end
    end

    --anchor last column's top right to the column container
    local lastColumn = columns[columnCount]
    lastColumn:SetPoint("TOPRIGHT")

    --todo update frame size to match visible column widths
end

function GuildUI_PopulateRows()
    local existingRows = { GuildUI_Frame_Roster_Rows:GetChildren() } or {}
    local existingRowCount = 0
    for _ in pairs(existingRows) do
        existingRowCount = existingRowCount + 1
    end

    --TODO: Sort and filter dataset here before populating the row frames

    local visiblePlayerCount = 0
    for _, player in pairs(GuildUI.Players) do

        local rowButton = existingRows[visiblePlayerCount] 
        if not rowButton then
            --initialize row frame and populate cell icons/fonts
            rowButton = CreateFrame("Button", "GuildUI_Row_" .. visiblePlayerCount, GuildUI_Frame_Roster_Rows, "GuildUI_RowTemplate")
            rowButton:SetPoint("TOP", 0, (visiblePlayerCount * rowButton:GetHeight()) * -1)
            rowButton.Player = player
            
            local padding = 0
            local cellCount = 0
            local rowCells = {}
            for i, columnDefinition in ipairs(ColumnDefinitions) do
                if not columnDefinition.Hidden then
                    local cellFrame
                    local cellName = "GuildUI_Row_" .. visiblePlayerCount .. "_Cell_".. cellCount
                    if columnDefinition.Type == ColumnTypes.Text then
                        cellFrame = rowButton:CreateFontString(cellName, "ARTWORK", "GameFontHighlightSmall")
                        cellFrame:SetSize(columnDefinition.Width,10)
                        cellFrame:SetWordWrap(false)
                        cellFrame:SetJustifyH(columnDefinition.Align)
                    elseif columnDefinition.Type == ColumnTypes.Icon then 
                        cellFrame = rowButton:CreateTexture(cellName, "ARTWORK")
                        cellFrame:SetSize(16,16)
                        cellFrame:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
                        cellFrame:SetTexCoord(0, 0.25, 0, 0.25)
                    elseif columnDefinition.Type == ColumnTypes.IconList then 
                        --TODO: Create a texture layer for each icon and place them appropriately within the column
                    end

                    --attach the cell to the previous cell (or the parent, if it's at either edge)
                    if cellCount > 0 then
                        local previousCell = rowCells[cellCount]
                        cellFrame:SetPoint("LEFT", previousCell, "RIGHT", padding, 0)
                    else
                        cellFrame:SetPoint("LEFT")
                    end

                    table.insert(rowCells, cellFrame)
                    cellCount = cellCount + 1
                end
            end
            rowCells[cellCount]:SetPoint("RIGHT", -padding, 0)
        end

        -- fill cell data
        local cellCount = 0
        for i, columnDefinition in ipairs(ColumnDefinitions) do
            if not columnDefinition.Hidden then
                local cellFrame = _G["GuildUI_Row_" .. visiblePlayerCount .. "_Cell_".. cellCount]
                if columnDefinition.Type == ColumnTypes.Text then
                    --print("Setting text to: ",  columnDefinition.PropertyName,  ": ", player[columnDefinition.PropertyName])
                    cellFrame:SetText(player[columnDefinition.PropertyName] or "")
                elseif columnDefinition.Type == ColumnTypes.Icon then 
                    --print("Setting icon to: ",  columnDefinition.PropertyName,  ": ", player[columnDefinition.PropertyName])
                    cellFrame:SetTexCoord(unpack(CLASS_ICON_TCOORDS[player[columnDefinition.PropertyName]]))                    
                elseif columnDefinition.Type == ColumnTypes.IconList then 
                    --TODO: Create a texture layer for each icon and place them appropriately within the column
                end
                cellCount = cellCount + 1
            end
        end

        visiblePlayerCount = visiblePlayerCount + 1
    end

    --hide extra rows
    local extraRowIndex = visiblePlayerCount + 1
    while existingRows[extraRowIndex] do
        existingRows[extraRowIndex]:Hide()
        extraRowIndex = extraRowIndex + 1
    end

    -- TODO: Adjust scrollable content height based on visible rows
end