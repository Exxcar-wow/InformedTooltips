local PREFIX = "[ITT]"
local ADDONNAME = "InformedTooltips"
local LINEBREAK = "----------------------------"
local ittVersion = "v0.2"

ITT = LibStub("AceAddon-3.0"):NewAddon(ADDONNAME, "AceConsole-3.0", "AceHook-3.0")

ITT.defaults = {
    char = {
        debug = true,
        enabled = true
    },
}

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
        self:PrintTable(self.db.char)
        self:PrintTable(self.db.global)
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
    -- Setup Hooks
    self:HookScript(GameTooltip, "OnTooltipSetItem")
    self:HookScript(GameTooltip.ItemTooltip.Tooltip, "OnTooltipSetItem")
    self:HookScript(ItemRefTooltip, "OnTooltipSetItem")
    self:HookScript(ShoppingTooltip1, "OnTooltipSetItem")
    self:HookScript(ShoppingTooltip2, "OnTooltipSetItem")
end

function ITT:OnDisable()
    self:Print(ADDONNAME,"disabled");
end

function ITT:OnTooltipSetItem(tooltip, ...)
    self:Print("Got a tooltip to process")

    local player = Player:new()
    local myItem = ITT_Item:NewFromTooltip(tooltip)

    if(not myItem) then
        return tooltip
    end

    if (self.db.char.debug) then
        self:PrintTable(player.raw)
        self:PrintTable(player.scales)
    end

    local tooltipTpye = tooltip:GetName() .. "TextLeft"

    return tooltip;
end