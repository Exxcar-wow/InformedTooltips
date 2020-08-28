local function updateScales()
    ITT.player.stats.crit = GetCombatRating(CRIT);
    if (ITT.player.stats.crit ~= 0) then
        ITT.player.scales.crit = GetCombatRatingBonus(CRIT) / ITT.player.stats.crit;
    else 
        ITT.player.scales.crit = 0.02874320913;
    end

    ITT.player.stats.haste = GetCombatRating(HASTE);
    if (ITT.player.stats.haste ~= 0) then
        ITT.player.scales.haste = GetCombatRatingBonus(HASTE) / ITT.player.stats.haste;
    else
        ITT.player.scales.haste = 0.03029901901;
    end

    ITT.player.stats.versatilityIn = GetCombatRating(VERSE_IN);
    if (ITT.player.stats.versatilityIn ~= 0) then
        ITT.player.scales.versatilityIn = GetCombatRatingBonus(VERSE_IN) / ITT.player.stats.versatilityIn;
    else
        ITT.player.scales.versatilityIn = 0.01252119530;
    end

    ITT.player.stats.versatilityOut = GetCombatRating(VERSE_OUT)
    if (ITT.player.stats.versatilityOut ~= 0) then
        ITT.player.scales.versatilityOut = GetCombatRatingBonus(VERSE_OUT) / ITT.player.stats.versatilityOut;
    else
        ITT.player.scales.versatilityOut = 0.02505618334;
    end

    ITT.player.stats.mastery = GetCombatRating(MASTERY)
    _, ITT.player.scales.masteryCoeffecient = GetMasteryEffect();
    if (ITT.player.stats.mastery ~= 0) then
        ITT.player.scales.mastery = GetCombatRatingBonus(MASTERY) / ITT.player.stats.mastery;
    else
        ITT.player.scales.mastery = 0.0285714284979592;
    end
end

local function updateTooltip(self)
    ITT.clearStorage();

    local name, itemLink = self:GetItem();

    if(itemLink == nil) then
        if (ITT.debug) then print("No item link found for " .. name) end
        return;
    end

    local itemID, itemType, itemSubType, itemEquipLoc, icon, itemClassID, itemSubClassID = GetItemInfoInstant(itemLink);

    if(itemType ~= "Armor" and itemType ~= "Weapon") then
        if (ITT.debug) then print("Skipping " .. name .. "(" .. itemType .. ")") end
        return;
    end

    local stats = {};

    ITT.tooltip.type = self:GetName() .. "TextLeft";

    stats = GetItemStats(itemLink);
    updateScales();

    if(ITT.debug) then
        printTable(stats);
    end

    for index,value in pairs(stats) do
        if (index == "ITEM_MOD_CRIT_RATING_SHORT") then
            ITT.item.raw.crit = value;
            ITT.item.percent.crit = round(value * ITT.player.scales.crit);
        elseif (index == "ITEM_MOD_HASTE_RATING_SHORT") then
            ITT.item.raw.haste = value;
            ITT.item.percent.haste = round(value * ITT.player.scales.haste);
        elseif (index == "ITEM_MOD_VERSATILITY") then
            ITT.item.raw.versatility = value;
            ITT.item.percent.versatilityOut = round(value * ITT.player.scales.versatilityOut);
            ITT.item.percent.versatilityIn = round(value * ITT.player.scales.versatilityIn);
        elseif (index == "ITEM_MOD_MASTERY_RATING_SHORT") then
            itemRawMast = value;
            itemPerMast = round((value * ITT.player.scales.mastery) * ITT.player.scales.masteryCoeffecient);
        end
    end

    for i=1, self:NumLines() do
        local currentIndex = ITT.tooltip.type..i;
        local line = _G[currentIndex];
        if line:GetText() then
            text = line:GetText()

            if(string.find(text, "Enchanted:")) then
                -- Parse Enchant Text
                _G[currentIndex]:SetText(parseEnchantText(text));
            elseif(string.find(text, "Equip:")) then
                -- Parse Equip Effect
                _G[currentIndex]:SetText(parseEquipText(text));
            elseif(string.find(text, "+")) then
                -- Parse Secondary Stats
                _G[currentIndex]:SetText(parseSecondaryText(text));
            end
		end
    end
end

SLASH_ITT1 = '/itt';

function SlashCmdList.ITT(msg, editbox)
    if msg == 'debug' then
        if (ITT.debug) then
            ITT.debug = false
            print("Debugging messages disabled");
        else
            ITT.debug = true
            print("Debugging messages should be enabled.");
        end
    end
end


--Hooks
GameTooltip:HookScript("OnTooltipSetItem", updateTooltip);
GameTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", updateTooltip);
ItemRefTooltip:HookScript("OnTooltipSetItem", updateTooltip);
ShoppingTooltip1:HookScript("OnTooltipSetItem", updateTooltip);
ShoppingTooltip2:HookScript("OnTooltipSetItem", updateTooltip);

print("Informed Tooltips loaded.");