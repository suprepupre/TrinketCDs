local ADDON_NAME = "TrinketCDs"
local ADDON_OPTIONS = "TrinketCDsOptions"
local ADDON = _G[ADDON_NAME]
local FRAMES = ADDON.FRAMES
local SWITCHES = ADDON.SETTINGS.SWITCHES
local SLIDER_NAME = ADDON_OPTIONS .. "%sSlider%s"
local EDITBOX_NAME = ADDON_OPTIONS .. "%sEditBox%s"
local DEFAULT_TRINKET_SWAP_LINK = "|cffffffff|Hitem:10725:0:0:0:0:0:0:0:80|h[Gnomish Battle Chicken]|h|r"

local OPTIONS_FRAME = CreateFrame("Frame")
ADDON.OPTIONS = OPTIONS_FRAME

-- Store slider references for updating after drag
OPTIONS_FRAME.item_sliders = {}

local MARGIN = 16
local SLIDERS = {
    ICON_SIZE = {
        row = 1,
        label = "Icon size",
        min = 20, max = 75,
    },
    POS_X = {
        row = 2,
        label = "Icon X",
        min = -2000, max = 2000,
        func = function(self)
            local w = floor(GetScreenWidth() / 2)
            self:SetMinMaxValues(-w, w)
            self.EditBox:Show()
        end
    },
    POS_Y = {
        row = 3,
        label = "Icon Y",
        min = -2000, max = 2000,
        func = function(self)
            local h = floor(GetScreenHeight() / 2)
            self:SetMinMaxValues(-h, h)
            self.EditBox:Show()
        end
    },
    ZOOM = {
        row = 4,
        label = "Icon zoom %",
        min = -200, max = 300, step = 5,
    },
    BORDER_MARGIN = {
        row = 5,
        label = "Border margin",
        min = -5, max = 5,
    },
    EDGE_SIZE = {
        row = 6,
        label = "Border edge",
        min = 1, max = 30,
    },
    ILVL_SIZE = {
        row = 7,
        label = "Item level font size %",
        min = 0, max = 100, step = 5,
    },
    STACKS_SIZE = {
        row = 8,
        label = "Stacks font size %",
        min = 0, max = 100, step = 5,
    },
    CD_SIZE = {
        row = 9,
        label = "Cooldown font size %",
        min = 0, max = 100, step = 5,
    },
}

local CB_DEFAULTS_MAIN = {
    COMBAT_ONLY = {
        row = 1,
        label = "Hide out of combat",
    },
    HIDE_READY = {
        row = 2,
        label = "Hide if ready (doesn't work with option below)",
    },
    USE_ON_CLICK = {
        row = 3,
        label = "Enable item activation with mouse (requires /reload)",
    },
    STACKS_BOTTOM = {
        row = 4,
        label = "Move stacks to the bottom of the frame",
    },
    SHOW_DECIMALS = {
        row = 5,
        label = "Show cooldown decimal (for built-in cooldown)",
        skip = true,
    },
    FORCE30 = {
        row = 6,
        label = "Force 30 seconds iCD on swap",
        skip = true,
    },
}

local show_slider_edit_box = function(self)
    self.EditBox:Show()
end

local function new_check_box(parent, frame_ID, row)
    local cb_id = frame_ID * 10 + row
    local name = parent.name .. "CheckBox" .. cb_id
    local checkBox = CreateFrame("CheckButton", name, parent, "InterfaceOptionsCheckButtonTemplate")
    local y = MARGIN * 2 * row
    checkBox:SetPoint("TOPLEFT", MARGIN, -y)
    checkBox.label = _G[name.."Text"]
    checkBox.item_frame = parent.item_frame
    return checkBox
end

local function cb_toggle_item_visibility(self)
    self.item_frame.settings.SHOW = self:GetChecked() and 1 or 0
    self.item_frame:ToggleVisibility()
end

local function cb_toggle_ilvl_visibility(self)
    if self:GetChecked() then
        self.item_frame.settings.SHOW_ILVL = 1
        self.item_frame.ilvl_text:Show()
    else
        self.item_frame.settings.SHOW_ILVL = 0
        self.item_frame.ilvl_text:Hide()
    end
end

local function edit_box_visual_bug_fix(slider, custom_func)
    slider.EditBox:Hide()
    slider:SetScript("OnShow", custom_func or show_slider_edit_box)
    slider.EditBox:SetScript("OnShow", function(f)
        f:SetText(slider:GetValue())
    end)
end

local function new_slider(parent_frame, option_name, properties)
    local settings = parent_frame.item_frame.settings
    local sliderID = SLIDER_NAME:format(parent_frame.name, option_name)
    local slider = CreateFrame("Slider", sliderID, parent_frame, "OptionsSliderTemplate")

    local y = (properties.row + 1.1) * MARGIN * 2
    slider:SetPoint("TOPLEFT", MARGIN, -y)
    slider:SetSize(250, 15)
    slider:SetMinMaxValues(properties.min, properties.max)
    slider:SetValueStep(properties.step or 1)
    slider:SetValue(settings[option_name])

    slider.InfoText = slider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    slider.InfoText:SetPoint("TOP", slider, 0, 20)
    slider.InfoText:SetSize(250, 20)
	slider.InfoText:SetJustifyH("CENTER")
    slider.InfoText:SetText(properties.label)

    local EditBoxID = EDITBOX_NAME:format(parent_frame.name, option_name)
    slider.EditBox = CreateFrame("EditBox", EditBoxID, slider, "InputBoxTemplate")
	slider.EditBox:SetPoint("LEFT", slider, "RIGHT", 10, 0)
	slider.EditBox:SetSize(50, 20)
    slider.EditBox:SetMaxLetters(5)
    slider.EditBox:SetJustifyH("RIGHT")
    slider.EditBox:SetMultiLine(false)
    slider.EditBox:SetAutoFocus(false)
    slider.EditBox:ClearFocus()
    edit_box_visual_bug_fix(slider, properties.func)

    slider.EditBox:SetScript("OnEscapePressed", slider.EditBox.ClearFocus)

    slider.EditBox:SetScript("OnEnterPressed", function(f)
        local value = f:GetText()
        if tonumber(value) then
            slider:SetValue(value)
            f:ClearFocus()
        else
            f:SetText(slider:GetValue())
        end
    end)

    slider:SetScript("OnValueChanged", function(f, value)
        settings[option_name] = value
        f.EditBox:SetText(value)
        parent_frame.item_frame:RedrawFrame()
    end)

    -- Store reference for updating after drag
    local slot_ID = parent_frame.item_frame.slot_ID
    if not OPTIONS_FRAME.item_sliders[slot_ID] then
        OPTIONS_FRAME.item_sliders[slot_ID] = {}
    end
    OPTIONS_FRAME.item_sliders[slot_ID][option_name] = slider

    return slider
end

-- Function to update sliders after drag & drop
function OPTIONS_FRAME:UpdateSliders(slot_ID)
    local sliders = self.item_sliders[slot_ID]
    if not sliders then return end

    local frame = FRAMES[slot_ID]
    if not frame then return end

    for option_name, slider in pairs(sliders) do
        local value = frame.settings[option_name]
        if value then
            slider:SetValue(value)
            slider.EditBox:SetText(value)
        end
    end
end

local function redraw_all()
    for _, frame in pairs(FRAMES) do
        frame:RedrawFrame()
    end
end

function OPTIONS_FRAME:add_main_settings()
    local frame_ID = 0
    local config_frame = CreateFrame("Frame", nil, self)
    config_frame.name = ADDON_NAME

    local title = config_frame:CreateFontString(nil, nil, "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", MARGIN, -MARGIN)
    title:SetText(format("%s %s" , ADDON_NAME, GetAddOnMetadata(ADDON_NAME, "Version")))

    for key, values in pairs(CB_DEFAULTS_MAIN) do
        local cb = new_check_box(config_frame, frame_ID, values.row)
        local properties = CB_DEFAULTS_MAIN[key]
        cb.label:SetText(properties.label)
        cb:SetChecked(SWITCHES[key] ~= 0)
        cb:SetScript("OnClick", function()
            SWITCHES[key] = cb:GetChecked() and 1 or 0
            if not properties.skip then redraw_all() end
        end)
    end

    InterfaceOptions_AddCategory(config_frame)
    self.main_options = config_frame
    return config_frame
end

function OPTIONS_FRAME:add_item_settings(slot_ID)
    local config_frame = CreateFrame("Frame", nil, self)
    config_frame.item_frame = FRAMES[slot_ID]

    local options_name = config_frame.item_frame.item_group
    config_frame.name = options_name
    config_frame.parent = self.main_options.name

    local title = config_frame:CreateFontString(nil, nil, "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", MARGIN, -MARGIN)
    title:SetText(options_name)

    local cb_show_lvl = new_check_box(config_frame, slot_ID, 1)
    cb_show_lvl.label:SetText("Show item level")
    cb_show_lvl:SetChecked(config_frame.item_frame.settings.SHOW_ILVL ~= 0)
    cb_show_lvl:SetScript("OnClick", cb_toggle_ilvl_visibility)

    for option_name, properties in pairs(SLIDERS) do
        new_slider(config_frame, option_name, properties)
    end

    InterfaceOptions_AddCategory(config_frame)
end

local function cb_pos(cb, i)
    local row = 7 + (i-i%2)/2
    local y = MARGIN * 2 * row
    local x = MARGIN + 120 * (i % 2)
    cb:SetPoint("TOPLEFT", x, -y)
end

local dropDown
local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
local function WPDropDownDemo_OnClick(self, arg1)
    UIDropDownMenu_SetText(dropDown, self.value)
    SWITCHES.FONT_FILE = arg1
    redraw_all()
end

local function sort_fonts_alpha(font_table)
    local _sorted = {}
    for font_name in pairs(font_table) do
        _sorted[#_sorted+1] = font_name
    end

    sort(_sorted, function(a, b) return a < b end)

    return _sorted
end

local function WPDropDownDemo_Menu(frame, level, menuList)
    local font_table = LSM:HashTable('font')
    local font_table_sorted = sort_fonts_alpha(font_table)

    local info = UIDropDownMenu_CreateInfo()
    info.func = WPDropDownDemo_OnClick
    info.text, info.arg1 = "Default", ""
    UIDropDownMenu_AddButton(info)
    UIDropDownMenu_SetText(dropDown, "Default")

    for _, font_name in ipairs(font_table_sorted) do
        local font_path = font_table[font_name]
        info.text, info.arg1 = font_name, font_path
        if font_path == SWITCHES.FONT_FILE then
            UIDropDownMenu_SetText(dropDown, font_name)
        end
        UIDropDownMenu_AddButton(info)
    end
end

local function add_trinket_swap_edit_box(config_frame)
    local swap_label = config_frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    swap_label:SetPoint("TOPLEFT", MARGIN, -MARGIN * 2 * 11.15)
    swap_label:SetText("Trinket to swap with ctrl:")

    local swap_info = config_frame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
    swap_info:SetPoint("TOPLEFT", MARGIN, -MARGIN * 2 * 12)
    swap_info:SetText("Click on edit box then click on item in inventory.")

    local item_id_eb = CreateFrame("EditBox", ADDON_NAME.."ItemSwapID", config_frame, "InputBoxTemplate")
    item_id_eb:SetPoint("TOPLEFT", MARGIN * 11, -MARGIN * 2 * 11)
	item_id_eb:SetSize(200, 20)
    item_id_eb:SetMultiLine(false)
    item_id_eb:SetAutoFocus(false)
    item_id_eb:ClearFocus()

    item_id_eb:SetScript("OnEditFocusGained", function()
        item_id_eb:RegisterEvent("CURSOR_UPDATE")
        item_id_eb:RegisterEvent("ITEM_LOCKED")
    end)

    item_id_eb:SetScript("OnEditFocusLost", function()
        item_id_eb:UnregisterEvent("CURSOR_UPDATE")
    end)

    item_id_eb:SetScript("OnEvent", function(f, arg1)
        if arg1 == "ITEM_LOCKED" then
            item_id_eb:UnregisterEvent("ITEM_LOCKED")
            ClearCursor()
        end
        local _, item_id, item_link = GetCursorInfo()
        if not item_id then return end

        item_id_eb:UnregisterEvent("CURSOR_UPDATE")
        item_id_eb:ClearFocus()
        if select(9, GetItemInfo(item_id)) ~= "INVTYPE_TRINKET" then
            print("Not a trinket:", item_link)
            return
        end

        item_id_eb:SetText(item_link)

        local char_profile = _G["TrinketCDsProfileChar"]
        if not char_profile then
            char_profile = {}
            _G["TrinketCDsProfileChar"] = char_profile
        end
        char_profile["trinket_swap_link"] = item_link
        ADDON.TRINKET_SWAP_ID = item_id
    end)
    item_id_eb:SetScript("OnShow", function ()
        local char_profile = _G["TrinketCDsProfileChar"]
        local item_link = char_profile and char_profile["trinket_swap_link"] or DEFAULT_TRINKET_SWAP_LINK
        item_id_eb:SetText(item_link)
    end)
end

-- ============================================================
-- Profile UI section
-- ============================================================
function OPTIONS_FRAME:add_profile_settings()
    local config_frame = CreateFrame("Frame", nil, self)
    config_frame.name = "Profiles"
    config_frame.parent = self.main_options.name

    local title = config_frame:CreateFontString(nil, nil, "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", MARGIN, -MARGIN)
    title:SetText("Profiles & Drag Mode")

    -- Drag unlock button
    local yOffset = -MARGIN * 3

    local drag_info = config_frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    drag_info:SetPoint("TOPLEFT", MARGIN, yOffset)
    drag_info:SetText("Drag mode allows you to move icons by dragging them.")
    yOffset = yOffset - 22

    local dragBtn = CreateFrame("Button", ADDON_NAME.."DragBtn", config_frame, "UIPanelButtonTemplate")
    dragBtn:SetPoint("TOPLEFT", MARGIN, yOffset)
    dragBtn:SetSize(220, 24)
    dragBtn:SetText("Toggle Drag Mode (/tcd drag)")
    dragBtn:SetScript("OnClick", function()
        ADDON:ToggleDragUnlock()
    end)
    yOffset = yOffset - 40

    -- Separator
    local sep1 = config_frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    sep1:SetPoint("TOPLEFT", MARGIN, yOffset)
    sep1:SetText("Save / Load Profiles")
    yOffset = yOffset - 25

    local profile_info = config_frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    profile_info:SetPoint("TOPLEFT", MARGIN, yOffset)
    profile_info:SetText("Select existing profile from dropdown or type a new name below.")
    yOffset = yOffset - 25

    -- Profile dropdown
    local profileDropDown = CreateFrame("Frame", ADDON_NAME.."ProfileDropDown", config_frame, "UIDropDownMenuTemplate")
    profileDropDown:SetPoint("TOPLEFT", MARGIN - 16, yOffset)
    UIDropDownMenu_SetWidth(profileDropDown, 200)

    -- Profile name edit box
    local eb_label = config_frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    eb_label:SetPoint("TOPLEFT", MARGIN, yOffset - 35)
    eb_label:SetText("Profile name:")

    local profile_eb = CreateFrame("EditBox", ADDON_NAME.."ProfileName", config_frame, "InputBoxTemplate")
    profile_eb:SetPoint("LEFT", eb_label, "RIGHT", 10, 0)
    profile_eb:SetSize(150, 20)
    profile_eb:SetMultiLine(false)
    profile_eb:SetAutoFocus(false)
    profile_eb:ClearFocus()
    profile_eb:SetScript("OnEscapePressed", profile_eb.ClearFocus)
    profile_eb:SetScript("OnEnterPressed", profile_eb.ClearFocus)
    yOffset = yOffset - 70

    local function ProfileDropDown_OnClick(self_btn)
        profile_eb:SetText(self_btn.value)
        UIDropDownMenu_SetText(profileDropDown, self_btn.value)
    end

    local function ProfileDropDown_Init()
        local list = ADDON:GetProfileList()
        local info = UIDropDownMenu_CreateInfo()
        for _, name in ipairs(list) do
            info.text = name
            info.value = name
            info.func = ProfileDropDown_OnClick
            UIDropDownMenu_AddButton(info)
        end
        if #list == 0 then
            info.text = "(no profiles)"
            info.value = ""
            info.disabled = true
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_Initialize(profileDropDown, ProfileDropDown_Init)
    UIDropDownMenu_SetText(profileDropDown, "Select profile...")

    -- Refresh dropdown every time the options panel is shown
    config_frame:SetScript("OnShow", function()
        UIDropDownMenu_Initialize(profileDropDown, ProfileDropDown_Init)
        UIDropDownMenu_SetText(profileDropDown, "Select profile...")
    end)

    -- Buttons
    local saveBtn = CreateFrame("Button", ADDON_NAME.."SaveProfileBtn", config_frame, "UIPanelButtonTemplate")
    saveBtn:SetPoint("TOPLEFT", MARGIN, yOffset)
    saveBtn:SetSize(100, 24)
    saveBtn:SetText("Save")
    saveBtn:SetScript("OnClick", function()
        local name = strtrim(profile_eb:GetText())
        if name == "" then
            print("|cFFFFFF00[TrinketCDs]|r: Enter a profile name first.")
            return
        end
        ADDON:SaveCurrentProfile(name)
    end)

    local loadBtn = CreateFrame("Button", ADDON_NAME.."LoadProfileBtn", config_frame, "UIPanelButtonTemplate")
    loadBtn:SetPoint("LEFT", saveBtn, "RIGHT", 8, 0)
    loadBtn:SetSize(100, 24)
    loadBtn:SetText("Load")
    loadBtn:SetScript("OnClick", function()
        local name = strtrim(profile_eb:GetText())
        if name == "" then
            print("|cFFFFFF00[TrinketCDs]|r: Enter a profile name first.")
            return
        end
        ADDON:LoadProfile(name)
        for slot_ID in pairs(FRAMES) do
            OPTIONS_FRAME:UpdateSliders(slot_ID)
        end
    end)

    local deleteBtn = CreateFrame("Button", ADDON_NAME.."DeleteProfileBtn", config_frame, "UIPanelButtonTemplate")
    deleteBtn:SetPoint("LEFT", loadBtn, "RIGHT", 8, 0)
    deleteBtn:SetSize(100, 24)
    deleteBtn:SetText("Delete")
    deleteBtn:SetScript("OnClick", function()
        local name = strtrim(profile_eb:GetText())
        if name == "" then
            print("|cFFFFFF00[TrinketCDs]|r: Enter a profile name first.")
            return
        end
        ADDON:DeleteProfile(name)
    end)
    yOffset = yOffset - 40

    -- Usage hints
    local hints_title = config_frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    hints_title:SetPoint("TOPLEFT", MARGIN, yOffset)
    hints_title:SetText("Chat commands:")
    yOffset = yOffset - 18

    local hints = {
        "|cFFFFFF00/tcd save <name>|r - save current layout",
        "|cFFFFFF00/tcd load <name>|r - load profile",
        "|cFFFFFF00/tcd delete <name>|r - delete profile",
        "|cFFFFFF00/tcd profiles|r - list all profiles",
        "|cFFFFFF00/tcd drag|r - toggle drag mode",
    }
    for _, hint_text in ipairs(hints) do
        local hint = config_frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        hint:SetPoint("TOPLEFT", MARGIN + 10, yOffset)
        hint:SetText(hint_text)
        yOffset = yOffset - 15
    end

    InterfaceOptions_AddCategory(config_frame)
end

function OPTIONS_FRAME:OnEvent(event, arg1)
    if arg1 ~= ADDON_NAME then return end

    local config_frame = self:add_main_settings()
    for i, slot_ID in ipairs(ADDON.SORTED_ITEMS) do
        self:add_item_settings(slot_ID)
        local item_frame = FRAMES[slot_ID]
        local cb_show = new_check_box(config_frame, slot_ID, 0)
        cb_show.label:SetText("Show " .. item_frame.item_group)
        cb_show:SetChecked(item_frame.settings.SHOW ~= 0)
        cb_show:SetScript("OnClick", cb_toggle_item_visibility)
        cb_show.item_frame = item_frame
        cb_pos(cb_show, i-1)
    end

    add_trinket_swap_edit_box(config_frame)

    if LSM then
        local font_font = config_frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        font_font:SetPoint("TOPLEFT", MARGIN, -MARGIN * 2 * 13.25)
        font_font:SetText("Font:")

        dropDown = CreateFrame("Frame", "WPDemoDropDown", config_frame, "UIDropDownMenuTemplate")
        dropDown:SetPoint("TOPLEFT", MARGIN * 3, -MARGIN * 2 * 13)
        UIDropDownMenu_SetWidth(dropDown, 200)
        UIDropDownMenu_Initialize(dropDown, WPDropDownDemo_Menu)
    end

    -- Profiles as separate subcategory
    self:add_profile_settings()
end

OPTIONS_FRAME:RegisterEvent("ADDON_LOADED")
OPTIONS_FRAME:SetScript("OnEvent", OPTIONS_FRAME.OnEvent)