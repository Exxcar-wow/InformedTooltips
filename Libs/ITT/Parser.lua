Parser = {
    Enchants = {
        ["Celestial Guidance"] = "Chance on hit: +5% PRIMARY STAT",
        ["Eternal Insight"] = "Chance on hit: +20 PRIMARY STAT & Shadow Damage",
        ["Soul Treads"] = "-10% Fall Damage",
        ["Shaded Hearthing"] = "Shadowlands Hearthstone CD -5 Minutes",
        ["Shadowlands Gathering"] = "Increased Gathering Speed in Shadowlands"
    },
    Gems = {
        ["Deadly Lava Lazuli"] = "+7 Crit"
    }
}


function Parser:enchantParser(text, player)
    if(ITT.db.char.debug) then ITT:Print("Parsing Enchant Text: " .. text) end
    for index,value in pairs(self.Enchants) do
        if(string.find(text, index)) then
            textFinal = text .. "\n   " .. string.gsub(value,"PRIMARY STAT", player.primaryStat);
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
    if(string.find(text, _G["ITEM_MOD_HASTE_RATING_SHORT"]) and percents.haste ~= nil) then
        text = text .. " (" .. tostring(percents.haste) .. "%)";
        percents.haste = nil
    elseif (string.find(text, _G["ITEM_MOD_CRIT_RATING_SHORT"]) and percents.crit ~= nil) then
        text = text .. " (" .. tostring(percents.crit) .. "%)";
        percents.crit = nil;
    elseif(string.find(text, _G["ITEM_MOD_VERSATILITY"]) and percents.versatilityOut ~= nil) then
        text = text .. " (" .. tostring(percents.versatilityOut) .. "% / " .. tostring(percents.versatilityIn ) .. "%)";
        percents.versatilityOut = nil;
    elseif(string.find(text, _G["ITEM_MOD_MASTERY_RATING_SHORT"]) and percents.mastery ~= nil) then
        text = text .. " (" .. tostring(percents.mastery) .. "%)";
        percents.mastery = nil;
    end
    return text;
end

function Parser:gemParser(gemName)
    if(ITT.db.char.debug) then ITT:Print("Working on Gem Text for: " ..gemName) end
end

function Parser:itemParser(text, parser)
    local questText, objectiveType, finished, fulfilled, required
    if(parser == 'razorwing') then
        questText, objectiveType, finished, fulfilled, required = GetQuestObjectiveInfo(64274, 0, false)
    elseif(parser == 'mawshroom') then
        questText, objectiveType, finished, fulfilled, required = GetQuestObjectiveInfo(64376, 0, false)
    end
    
    text = text .. " (" .. tostring(fulfilled) .. " / " .. tostring(required) .. ")";
    return text;
end