ITT = {}
ITT.debug = false

--Tooltip Storage
ITT.tooltip = {}
ITT.tooltip.type = "";

--Player Storage
ITT.player = {}
ITT.player.scales = {}
ITT.player.scales.crit = 0;
ITT.player.scales.haste = 0;
ITT.player.scales.mastery = 0;
ITT.player.scales.versatilityIn = 0;
ITT.player.scales.versatilityOut = 0;

ITT.player.stats = {}
ITT.player.stats.crit = 0;
ITT.player.stats.haste = 0;
ITT.player.stats.mastery = 0;
ITT.player.stats.versatilityIn = 0;
ITT.player.stats.versatilityOut = 0;

--Item Storage
ITT.item = {}
ITT.item.raw = {}
ITT.item.raw.crit = 0;
ITT.item.raw.haste = 0;
ITT.item.raw.mastery = 0;
ITT.item.raw.versatility = 0;

ITT.item.percent = {}
ITT.item.percent.crit = 0;
ITT.item.percent.haste = 0;
ITT.item.percent.mastery = 0;
ITT.item.percent.versatilityIn = 0;
ITT.item.percent.versatilityOut = 0;

defaultItemStorage = ITT.item
defaultToolTipStorage = ITT.tooltip
defaultPlayerStorage = ITT.player

--ITT Util functions
ITT.tooltip.clear = function ()
    ITT.tooltip = defaultToolTipStorage
end

ITT.player.clear = function ()
end

ITT.item.clear = function ()
    ITT.item = defaultItemStorage
end

ITT.clearStorage = function ()
    ITT.tooltip.clear()
    ITT.player.clear()
    ITT.item.clear()
end