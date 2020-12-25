local PREFIX = "[ITT]"
local ADDONNAME = "InformedTooltips"
local LINEBREAK = "----------"
local ittVersion = "v0.2"

ITT = LibStub("AceAddon-3.0"):NewAddon(ADDONNAME, "AceConsole-3.0", "AceHook-3.0")

ITT.defaults = {
    char = {
        debug = false,
        enabled = true
    },
}

ITT.previousID = 0
ITT.previousTooltip = {}

function ITT:PrintTable(myTable, header)
    header = header or "myTable"
    self:Print(LINEBREAK, header, LINEBREAK)
    for index,value in pairs(myTable) do
        self:Print(index, ": ", value);
    end
    self:Print(LINEBREAK, header, "End", LINEBREAK)
end

function ITT:OnInitialize()
    self:Print("ITT beginning initialization")
    self.db = LibStub("AceDB-3.0"):New("ITTDB", self.defaults)

    if (self.db.char.debug) then
        self:Print("Debugging messages enabled")
    else
        self:Print("Debugging messages disabled")
    end

    C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)

    -- Register Chat Comands
    self:RegisterChatCommand("itt", "ChatCommandHandler")
    self:RegisterChatCommand("rl", function(self)
        ReloadUI()
    end)
    self:Print(ADDONNAME, " Initialized");

    if (not self.db.char.enabled) then
        self:Disable()
    end
end

function ITT:ChatCommandHandler(msg)
    local command, text = msg:match("(%S+)%s*(%S*)")
    if (command == "debug") then
        self.db.char.debug = not self.db.char.debug

        if(self.db.char.debug) then
            self:Print("Debugging messages enabled")
        else
            self:Print("Debugging messages disabled")
        end
    elseif (command == "toggle") then
        self.db.char.enabled = not self.db.char.enabled

        if(self.db.char.enabled) then
            self:Enable()
        else
            self:Disable()
        end
    elseif (command == "help") then
        self:Print("/itt toggle : toggles tooltip enhancements")
        self:Print("/itt debug : toggles debug messages for development")
    else
        self:Print("Usage: /itt <command>\n")
        self:Print("/itt help for a list of commands")
    end
end

function ITT:OnEnable()
    self:Print(ADDONNAME, ittVersion ,"enabled");

    -- Event for mousing over item in Bag
    self:SecureHook(GameTooltip, "SetBagItem", "CreateInformedTooltip")

    -- Events for merchant buyback pane and normal pane
    self:SecureHook(GameTooltip, "SetBuybackItem", "CreateInformedTooltip")
    self:SecureHook(GameTooltip, "SetMerchantItem", "CreateInformedTooltip")

    -- Event for mousing over item in bank OR bag in bag bar
    self:SecureHook(GameTooltip, "SetInventoryItem", "CreateInformedTooltip")

    -- Event for mousing over item in guild bank
    self:SecureHook(GameTooltip, "SetGuildBankItem", "CreateInformedTooltip")

    -- Event for mousing over item in recipe page for tradeskill window
    self:SecureHook(GameTooltip, "SetRecipeResultItem", "CreateInformedTooltip")

    -- Event for mousing over item in loot window
    self:SecureHook(GameTooltip, "SetLootItem", "CreateInformedTooltip")

    -- Event for clicking on an item link (like in chat)
    self:SecureHook(ItemRefTooltip, "SetHyperlink", "CreateInformedTooltip")

    -- Events for Quest Dialog and Quest Log
    self:SecureHook(GameTooltip, "SetQuestItem", "CreateInformedTooltip")
    self:SecureHook(GameTooltip, "SetQuestLogItem", "CreateInformedTooltip")
end

function ITT:OnDisable()
    self:Print(ADDONNAME,"disabled");
end

function ITT:CreateInformedTooltip(tooltip, ...)
    if(self.db.char.debug) then self:Print("Parsing a new item!") end
    local player = Player:new()
    local myItem = ITT_Item:NewFromTooltip(tooltip)

    if(not myItem) then
        return tooltip
    end

    if(myItem.stats.raw.crit) then
        myItem.stats.percent.crit = round(myItem.stats.raw.crit * player.scales.crit)
    end

    if(myItem.stats.raw.haste) then
        myItem.stats.percent.haste = round(myItem.stats.raw.haste * player.scales.haste)
    end

    if(myItem.stats.raw.mastery) then
        myItem.stats.percent.mastery = round((myItem.stats.raw.mastery * player.scales.mastery) * player.scales.masteryCoeffecient);
    end

    if(myItem.stats.raw.versatility) then
        myItem.stats.percent.versatilityIn = round(myItem.stats.raw.versatility * player.scales.versatilityIn);
        myItem.stats.percent.versatilityOut = round(myItem.stats.raw.versatility * player.scales.versatilityOut);
    end

    if(self.db.char.debug) then ITT:PrintTable(myItem.stats.percent, "Item Percents") end

    local tooltipTpye = tooltip:GetName() .. "TextLeft"
    for i=1, tooltip:NumLines() do
        local currentIndex = tooltipTpye..i
        local line = _G[currentIndex]

        if (line:GetText()) then
            text = line:GetText()

            if(string.find(text, "Enchanted:")) then
                -- Parse Enchant Text
                _G[currentIndex]:SetText(Parser:enchantParser(text, player))
            elseif(string.find(text, "Equip:")) then
                -- Parse Equip Effect
                _G[currentIndex]:SetText(Parser:equipParser(text))
            elseif(string.find(text, "+")) then
                -- Parse Secondary Stats
                _G[currentIndex]:SetText(Parser:secondaryParser(text, myItem.stats.percent))
            end
        end
    end

    self.previousID = myItem.ID
    self.previousTooltip = tooltip

    return tooltip;
end


-- Util Functions

function round(number, decimalPlaces)
    return tonumber(string.format("%." .. (decimalPlaces or 3) .. "f", number));
end