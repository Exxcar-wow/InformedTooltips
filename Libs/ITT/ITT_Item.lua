ITT_Item = {
    ID = 0,
    name = '',
    link = '',
    type = '',
    subType = '',
    equipLoc = '',
    icon = 0,
    classID = 0,
    subClassID = 0,
    stats = {
        raw = {
            crit = nil,
            haste = nil,
            versatility = nil,
            mastery = nil
        },
        percent = {
            crit = nil,
            haste = nil,
            versatilityIn = nil,
            versatilityOut = nil,
            mastery = nil
        },
    }
}

function ITT_Item:new(i)
    i = i or {}
    setmetatable(i, self)
    self.__index = self
    return i
end

function ITT_Item:NewFromTooltip(tooltip)
    i = {}
    setmetatable(i, self)
    self.__index = self
    self.name, self.link = tooltip:GetItem()

    if (self.link == nil) then
        if (ITT.db.char.debug) then ITT:Print("No item link found for", self.name) end
        return nil
    end

    self.ID,
    self.type,
    self.subType,
    self.equipLoc,
    self.icon,
    self.classID,
    self.subClassID = GetItemInfoInstant(self.link)

    if(self.type ~= "Armor" and self.type ~= "Weapon") then
        if(ITT.db.char.debug) then ITT:Print("Skipping" , self.name , "(" , self.type , ")") end
        return nil;
    end

    local stats = GetItemStats(self.link)
    
    for index,value in pairs(stats) do
        if (index == "ITEM_MOD_CRIT_RATING_SHORT") then
            self.stats.raw.crit = value;
        elseif (index == "ITEM_MOD_HASTE_RATING_SHORT") then
            self.stats.raw.haste = value;
        elseif (index == "ITEM_MOD_VERSATILITY") then
            self.stats.raw.versatility = value;
        elseif (index == "ITEM_MOD_MASTERY_RATING_SHORT") then
            self.stats.raw.mastery = value;
        end
    end
    if(ITT.db.char.debug) then ITT:PrintTable(self.stats.raw, "Item Raw Stats") end
    return i
end