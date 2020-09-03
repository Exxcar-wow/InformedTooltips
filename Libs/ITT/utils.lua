function round(number, decimalPlaces)
    return tonumber(string.format("%." .. (decimalPlaces or 3) .. "f", number));
end

function printTable(myTable)
    print("----------------------------")
    for index,value in pairs(myTable) do
        print(index .. " : " .. value);
    end
    print("----------------------------")
end

function processLine(text)
    print(text)
end

function determineMainStat()
    local primaryStat = "";

    local playerSpec = GetSpecialization()
    local specID, currentSpecName, _, _, _, _, primaryStat = GetSpecializationInfo(playerSpec)

    if(primaryStat == 1) then
        primaryStat = _G["ITEM_MOD_STRENGTH_SHORT"]
    elseif(primaryStat == 2) then
        primaryStat = _G["ITEM_MOD_AGILITY_SHORT"]
    else
        primaryStat = _G["ITEM_MOD_INTELLECT_SHORT"]
    end

    return primaryStat;
end