-- 🐗 Bizon Hub UI-2b (Label)
local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme

local function findTabByParent(parent)
    for name, tab in pairs(Hub.Tabs) do
        if tab.container == parent then return name end
    end
    return nil
end

function Hub.createLabel(parent, text)
    local tabName = findTabByParent(parent)
    
    -- Сбрасываем ТОЛЬКО в таблице вкладки (не в ScrollingFrame!)
    if tabName and Hub.Tabs[tabName] and type(Hub.Tabs[tabName]) == "table" then
        Hub.Tabs[tabName].currentRow = nil
        Hub.Tabs[tabName].colCount = 0
    end
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 26)
    label.BackgroundTransparency = 1
    label.Text = "— " .. string.upper(text) .. " —"
    label.TextColor3 = T.TextDim
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.Parent = parent
    return label
end

print("🐗 UI-2b загружен (Label)")
