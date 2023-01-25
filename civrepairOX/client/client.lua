

ESX = nil
local ox_target = exports.ox_target
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local GetWorldPositionOfEntityBone = GetWorldPositionOfEntityBone
local GetVehicleDoorLockStatus = GetVehicleDoorLockStatus

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        if ESX == nil then
            ESX = exports["es_extended"]:getSharedObject()
        end
        Citizen.Wait(0)
    end
end)

local vehicle = nil

RegisterNetEvent('repairVehicle')
AddEventHandler('repairVehicle', function(vehicle)
    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(PlayerId())
    vehicle   = ESX.Game.GetClosestVehicle()
    if vehicle ~= nil then
        if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
                TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
                Citizen.Wait(20000)
                SetVehicleFixed(vehicle)
		        SetVehicleDeformationFixed(vehicle)
		        SetVehicleUndriveable(vehicle, false)
                ClearPedTasksImmediately(playerPed)
                TriggerServerEvent('repairCompleted', playerId)
                ESX.ShowNotification("Your vehicle has been repaired!")
        else
            ESX.ShowNotification("You must target a vehicle that you are not inside of to repair it.")
        end
    else
        ESX.ShowNotification("There is no vehicle nearby.")
    end
end)



local function repairVehicleOX()
    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(PlayerId())
    local vehicle = ESX.Game.GetClosestVehicle()
    if vehicle ~= nil then
        TriggerServerEvent('validateRepairVehicle', playerId)
    end
end

local options = {
    {
        name = 'ox_target:repair',
        icon = 'fa-solid fa-wrench',
        label = 'Repair',
        bones = 'engine',
        canInteract = function(entity, distance, coords, name, boneId)
            if GetVehicleDoorLockStatus(entity) > 1 then return end
            return #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 0.9
        end,
        onSelect = function(data)
            repairVehicleOX(data.entity, 0)
        end
    }
}

ox_target:addGlobalVehicle(options)
