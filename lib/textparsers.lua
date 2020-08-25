spacing = "\n   "
Enchants = {}
Enchants = {
    ["Celestial Guidance"] = "Chance on hit: +5% PRIMARY STAT",
    ["Eternal Insight"] = "Chance on hit: +20 PRIMARY STAT & Shadow Damage",
    ["Soul Treads"] = "-10% Fall Damage",
    ["Shaded Hearthing"] = "Shadowlands Hearthstone CD -5 Minutes",
    ["Shadowlands Gathering"] = "Increased Gathering Speed in Shadowlands"
}

function parseEnchantText(text)
    for index,value in pairs(Enchants) do
        if(ITT.debug) then print(index .. " => " .. value ) end
        if(string.find(text, index)) then
            textFinal = text .. spacing .. string.gsub(value,"PRIMARY STAT",determineMainStat())
            return textFinal
        end
    end
    return text
end

function parseEquipText(text)
    return text
end


function parseSecondaryText(text)
    if(string.find(text, _G["ITEM_MOD_HASTE_RATING_SHORT"]) and ITT.item.raw.haste ~= 0) then
        text = text .. " (" .. tostring(ITT.item.percent.haste) .. "%)";
        -- _G[ITT.tooltip.type..i]:SetText("+" .. ITT.item.raw.haste .. " " .. _G["ITEM_MOD_HASTE_RATING_SHORT"] .. " (" .. tostring(ITT.item.percent.haste) .. "%)");
    elseif (string.find(text, _G["ITEM_MOD_CRIT_RATING_SHORT"]) and ITT.item.raw.crit ~= 0) then
        text = text .. " (" .. tostring(ITT.item.percent.crit) .. "%)";
        -- _G[ITT.tooltip.type..i]:SetText("+" .. ITT.item.raw.crit .. " " .. _G["ITEM_MOD_CRIT_RATING_SHORT"] .. " (" .. tostring(ITT.item.raw.crit) .. "%)");
    elseif(string.find(text, _G["ITEM_MOD_VERSATILITY"]) and ITT.item.raw.versatility ~= 0) then
        text = text .. " (" .. tostring(ITT.item.percent.versatilityOut) .. "% / " .. tostring(ITT.item.percent.versatilityIn ) .. "%)"
        -- _G[ITT.tooltip.type..i]:SetText("+" .. ITT.item.raw.versatility .. " " .. _G["ITEM_MOD_VERSATILITY"] .. " (" .. tostring(ITT.item.percent.versatilityOut) .. "% / " .. tostring(ITT.item.percent.versatilityIn ) .. "%)");
    elseif(string.find(text, _G["ITEM_MOD_MASTERY_RATING_SHORT"]) and itemRawMast ~= 0) then
        text = text .. " (" .. tostring(itemPerMast) .. "%)"
        -- _G[ITT.tooltip.type..i]:SetText("+" .. itemRawMast .. " " .. _G["ITEM_MOD_MASTERY_RATING_SHORT"] .. " (" .. tostring(itemPerMast) .. "%)");
    end
    return text
end