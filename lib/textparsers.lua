spacing = "\n   ";
Enchants = {};
Enchants = {
    ["Celestial Guidance"] = "Chance on hit: +5% PRIMARY STAT",
    ["Eternal Insight"] = "Chance on hit: +20 PRIMARY STAT & Shadow Damage",
    ["Soul Treads"] = "-10% Fall Damage",
    ["Shaded Hearthing"] = "Shadowlands Hearthstone CD -5 Minutes",
    ["Shadowlands Gathering"] = "Increased Gathering Speed in Shadowlands"
};

function parseEnchantText(text)
    for index,value in pairs(Enchants) do
        if(string.find(text, index)) then
            textFinal = text .. spacing .. string.gsub(value,"PRIMARY STAT",determineMainStat());
            return textFinal;
        end
    end
    if(string.find(text, _G["ITEM_MOD_MASTERY_RATING_SHORT"])) then
        text = text;
    end
    return text;
end

function parseEquipText(text)
    return text;
end


function parseSecondaryText(text)
    if(string.find(text, _G["ITEM_MOD_HASTE_RATING_SHORT"]) and ITT.item.raw.haste ~= 0) then
        text = text .. " (" .. tostring(ITT.item.percent.haste) .. "%)";
    elseif (string.find(text, _G["ITEM_MOD_CRIT_RATING_SHORT"]) and ITT.item.raw.crit ~= 0) then
        text = text .. " (" .. tostring(ITT.item.percent.crit) .. "%)";
    elseif(string.find(text, _G["ITEM_MOD_VERSATILITY"]) and ITT.item.raw.versatility ~= 0) then
        text = text .. " (" .. tostring(ITT.item.percent.versatilityOut) .. "% / " .. tostring(ITT.item.percent.versatilityIn ) .. "%)";
    elseif(string.find(text, _G["ITEM_MOD_MASTERY_RATING_SHORT"]) and itemRawMast ~= 0) then
        text = text .. " (" .. tostring(itemPerMast) .. "%)";
    end
    return text;
end