ITT = {}

--Tooltip Storage
ITT.tooltip = {};
ITT.tooltip.type = nil;

--Player Storage
ITT.player = {};
ITT.player.scales = {};
ITT.player.scales.crit = nil;
ITT.player.scales.haste = nil;
ITT.player.scales.mastery = nil;
ITT.player.scales.versatilityIn = nil;
ITT.player.scales.versatilityOt = nil;
ITT.player.scales.masteryCoeffecient = nil;

ITT.player.stats = {};
ITT.player.stats.crit = nil;
ITT.player.stats.haste = nil;
ITT.player.stats.mastery = nil;
ITT.player.stats.versatilityIn = nil;
ITT.player.stats.versatilityOut = nil;

--Item Storage
ITT.item = {};
ITT.item.name = nil;
ITT.item.itemLink = nil;
ITT.item.itemID = nil;
ITT.item.itemType = nil;
ITT.item.subType = nil;
ITT.item.itemEquipLoc = nil;
ITT.item.icon = nil;
ITT.item.itemClassID = nil;
ITT.item.itemSubClassID = nil;

-- Item Stat Storage
ITT.item.raw = {};
ITT.item.raw.crit = nil;
ITT.item.raw.haste = nil;
ITT.item.raw.mastery = nil;
ITT.item.raw.versatility = nil;

ITT.item.percent = {};
ITT.item.percent.crit = nil;
ITT.item.percent.haste = nil;
ITT.item.percent.mastery = nil;
ITT.item.percent.versatilityIn = nil;
ITT.item.percent.versatilityOut = nil;

defaultItemStorage = ITT.item;
defaultToolTipStorage = ITT.tooltip;
defaultPlayerStorage = ITT.player;

--ITT Util functions
ITT.tooltip.clear = function ()
    ITT.tooltip = defaultToolTipStorage;
end

ITT.player.clear = function ()
    ITT.player = defaultPlayerStorage;
end

ITT.item.clear = function ()
    ITT.item = defaultItemStorage;
end

ITT.clearStorage = function ()
    ITT.tooltip.clear();
    ITT.player.clear();
    ITT.item.clear();
end


-- Populates storage
-- Return False if unsupported item type
ITT.GetData = function (tooltip)
    ITT.clearStorage();
    ITT.item.clear();
    ITT.tooltip.clear();

    ITT.item.name, ITT.item.itemLink = tooltip:GetItem();

    if(ITT.item.itemLink == nil) then
        if (ITT.debug) then print("No item link found for " .. ITT.item.name) end
        return false;
    end     

    ITT.item.itemID,
    ITT.item.itemType,
    ITT.item.itemSubType,
    ITT.item.itemEquipLoc,
    ITT.item.icon,
    ITT.item.itemClassID,
    ITT.item.itemSubClassID = GetItemInfoInstant(ITT.item.itemLink)

    if(ITT.item.itemType ~= "Armor" and ITT.item.itemType ~= "Weapon") then
        if(ITT.debug) then print("Skipping" .. ITT.item.name .. "(" .. ITT.item.itemType .. ")") end
        return false;
    end
    return true;
end
