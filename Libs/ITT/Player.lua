local CRIT = 11;
local HASTE = 20;
local VERSE_OUT = 29;
local VERSE_IN = 31;
local MASTERY = 26;

Player = {
    primaryStat = "",
    raw = {
        crit = 0,
        haste = 0,
        versatilityIn = 0,
        versatilityOut = 0,
        mastery = 0
    },
    scales = {
        crit = 0.02874320913,
        haste = 0.03029901901,
        versatilityIn = 0.01252119530,
        versatilityOut = 0.02505618334,
        mastery = 0.0285714284979592,
        masteryCoeffecient = 0
    }
}

function Player:new(p)
    p = p or {}
    setmetatable(p, self)
    self.__index = self
    self.raw.crit = GetCombatRating(CRIT)
    self.raw.haste = GetCombatRating(HASTE)
    self.raw.versatilityIn = GetCombatRating(VERSE_IN)
    self.raw.versatilityOut = GetCombatRating(VERSE_OUT)
    self.raw.mastery = GetCombatRating(MASTERY)
    
    _, self.scales.masteryCoeffecient = GetMasteryEffect();

    if(self.raw.crit > 0 ) then
        self.scales.crit = GetCombatRatingBonus(CRIT) / self.raw.crit
    end

    if(self.raw.haste > 0) then
        self.scales.haste = GetCombatRatingBonus(HASTE) / self.raw.haste
    end

    if (self.raw.versatilityIn ~= 0) then
        self.scales.versatilityIn = GetCombatRatingBonus(VERSE_IN) / self.raw.versatilityIn;
    end

    if (self.raw.versatilityOut ~= 0) then
        self.scales.versatilityOut = GetCombatRatingBonus(VERSE_OUT) / self.raw.versatilityOut;
    end

    if (self.raw.mastery ~= 0) then
        self.scales.mastery = GetCombatRatingBonus(MASTERY) / self.raw.mastery;
    end

    local playerSpec = GetSpecialization()
    local _, _, _, _, _, _, primaryStat = GetSpecializationInfo(playerSpec)

    if(primaryStat == 1) then
        self.primaryStat = _G["ITEM_MOD_STRENGTH_SHORT"]
    elseif(primaryStat == 2) then
        self.primaryStat = _G["ITEM_MOD_AGILITY_SHORT"]
    else
        self.primaryStat = _G["ITEM_MOD_INTELLECT_SHORT"]
    end
    
    return p
end