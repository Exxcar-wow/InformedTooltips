Parser = {
    spacing = "\n   ",
    Enchants = {
        ["Celestial Guidance"] = "Chance on hit: +5% PRIMARY STAT",
        ["Eternal Insight"] = "Chance on hit: +20 PRIMARY STAT & Shadow Damage",
        ["Soul Treads"] = "-10% Fall Damage",
        ["Shaded Hearthing"] = "Shadowlands Hearthstone CD -5 Minutes",
        ["Shadowlands Gathering"] = "Increased Gathering Speed in Shadowlands"
    },
}


function Parser:enchantParser(text)
    for index,value in pairs(self.Enchants) do
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

function Parser:equipParser(text)
    return text;
end


function Parser:secondaryParser(text, percents)
    if(string.find(text, _G["ITEM_MOD_HASTE_RATING_SHORT"])) then
        text = text .. " (" .. tostring(percents.haste) .. "%)";
    elseif (string.find(text, _G["ITEM_MOD_CRIT_RATING_SHORT"])) then
        text = text .. " (" .. tostring(percents.crit) .. "%)";
    elseif(string.find(text, _G["ITEM_MOD_VERSATILITY"])) then
        text = text .. " (" .. tostring(percents.versatilityOut) .. "% / " .. tostring(percents.versatilityIn ) .. "%)";
    elseif(string.find(text, _G["ITEM_MOD_MASTERY_RATING_SHORT"])) then
        text = text .. " (" .. tostring(percents.mastery) .. "%)";
    end
    return text;
end