ESX = nil
local xPlayer = nil
while ESX == nil  do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    if ESX == nil then
        ESX = exports["es_extended"]:getSharedObject()
    end
end



RegisterServerEvent('validateRepairVehicle')
AddEventHandler('validateRepairVehicle', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    Wait(100)
    if xPlayer then
        local items = {
        {name = "repairkit", count = 0}
        }

        for i=1, #items, 1 do
            local item = xPlayer.getInventoryItem(items[i].name)
            if item and item.count > items[i].count then
                TriggerClientEvent('repairVehicle', source, true)
            else
                TriggerClientEvent('esx:showNotification', source, 'You do not have a repair kit', msg, 1000)
            end
        end
    else
    end
end)

RegisterServerEvent('repairCompleted')
AddEventHandler('repairCompleted', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local item = xPlayer.getInventoryItem('repairkit')
        if item and item.count > 0 then
            xPlayer.removeInventoryItem('repairkit', 1)
        else
            TriggerClientEvent('esx:showNotification', source, 'You do not have a repair kit')
        end
    else
    end
end)

