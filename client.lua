ESX = nil

local loop = false
local mati = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Citizen.CreateThread(function()
--     while true do
-- 		Citizen.Wait(500)
-- 		ESX.TriggerServerCallback('nz_autorevive:getConnectedEMS', function(amount)
-- 			local ped = PlayerPedId()
-- 			if amount < Config.ServiceCount and IsEntityDead(ped) then
-- 				print("ems enggaa cukup")
-- 				Citizen.Wait(10)
-- 				TriggerEvent('nz_autorevive:revive', ped)
-- 			else
-- 				print("ems cukup")
-- 			end
-- 		end)
--     end
-- end)

AddEventHandler('esx:onPlayerDeath', function(data)
    mati = true
end)

AddEventHandler('playerSpawned', function(spawn)
    mati = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		ESX.TriggerServerCallback('nz_autorevive:getConnectedEMS', function(amount)

			if amount < Config.ServiceCount then
				loop = true
			else
				loop = false
			end

		end)

	end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1000)
		
		if loop then
			--print("loop")

			if mati then
				Citizen.Wait(100)
				print("revive")
				TriggerEvent('nz_autorevive:revive', ped)
			end

		else
			Citizen.Wait(500)
		end
		
    end
end)

AddEventHandler('nz_autorevive:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('nz_autorevive:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(playerPed, formattedCoords, 0.0)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
	end)
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end