ESX = nil 

local player = GetPlayerPed(-1)

local coords = GetEntityCoords(player)

---------------------------------

-------- Message F8  ------------

---------------------------------

print ("^1Made by : ^3ZeBee#0433") 

print ("^2Discord  : ^4https://discord.gg/vzbjvdatzH") 

---------------------------------

-- Get the ESX library --

---------------------------------



Citizen.CreateThread(function()

    while ESX == nil do

        Citizen.Wait(10)

        TriggerEvent("esx:getSharedObject", function(obj)

        ESX = obj

        end)

    end

end)





---------------------------------

---- Desactivate roll ----

---------------------------------

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(5)

        if IsControlPressed(0, 25)

            then DisableControlAction(0, 22, true)

        end

    end

end) 





---------------------------------

------ Desactivate driveby -------

---------------------------------

local passengerDriveBy = false



Citizen.CreateThread(function()

    while true do

        Wait(1)



        playerPed = GetPlayerPed(-1)

        car = GetVehiclePedIsIn(playerPed, false)

        if car then

            if GetPedInVehicleSeat(car, -1) == playerPed then

                SetPlayerCanDoDriveBy(PlayerId(), false)

            elseif passengerDriveBy then

                SetPlayerCanDoDriveBy(PlayerId(), true)

            else

                SetPlayerCanDoDriveBy(PlayerId(), false)

            end

        end

    end

end) 







---------------------------------

--------- Put the train ---------- 

---------------------------------

Citizen.CreateThread(function()

    SwitchTrainTrack(0, true)

    SwitchTrainTrack(3, true)

    N_0x21973bbf8d17edfa(0, 120000)

    SetRandomTrains(true)

end) 





---------------------------------

--- DISABLE CROSS STRIKES ---- 

---------------------------------

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(0)

    local ped = PlayerPedId()

        if IsPedArmed(ped, 6) then

           DisableControlAction(1, 140, true)

              DisableControlAction(1, 141, true)

           DisableControlAction(1, 142, true)

        end

    end

end)





---------------------------------

------- No drop weapon pnj -------- 

---------------------------------

Citizen.CreateThread(function()

  while true do

    Citizen.Wait(1)

    -- List of pickup hashes (https://pastebin.com/8EuSv2r1)

    RemoveAllPickupsOfType(0xDF711959) -- carbine rifle

    RemoveAllPickupsOfType(0xF9AFB48F) -- pistol

    RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun

  end

end)

-- DISABLE AUTO PLACE CHANGE

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)



-- GET ON THE REAR OF THE VEHICLE

local doors = {
	{"seat_dside_f", -1},
	{"seat_pside_f", 0},
	{"seat_dside_r", 1},
	{"seat_pside_r", 2}
}

function VehicleInFront(ped)
    local pos = GetEntityCoords(ped)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
	
    return result
end

Citizen.CreateThread(function()
	while true do
    	Citizen.Wait(0)
			
		local ped = PlayerPedId()
			
   		if IsControlJustReleased(0, 23) and running ~= true and GetVehiclePedIsIn(ped, false) == 0 then
      		local vehicle = VehicleInFront(ped)
				
      		running = true
				
      		if vehicle ~= nil then
				local plyCoords = GetEntityCoords(ped, false)
        		local doorDistances = {}
					
        		for k, door in pairs(doors) do
          			local doorBone = GetEntityBoneIndexByName(vehicle, door[1])
          			local doorPos = GetWorldPositionOfEntityBone(vehicle, doorBone)
          			local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, doorPos.x, doorPos.y, doorPos.z)
						
          			table.insert(doorDistances, distance)
        		end
					
        		local key, min = 1, doorDistances[1]
					
        		for k, v in ipairs(doorDistances) do
          			if doorDistances[k] < min then
           				key, min = k, v
          			end
        		end
					
        		TaskEnterVehicle(ped, vehicle, -1, doors[key][2], 1.5, 1, 0)
     		end
				
      		running = false
    	end
  	end
end)

-- KEYBIND CHANGE PLACE VEHICLE
Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- We define the speed of the vehicle in km/h
			if CarSpeed <= 40.0 then -- You cannot change places if the speed of the vehicle is above or equal to 60 km/h
				if IsControlJustReleased(0, 157) then -- driver
					SetPedIntoVehicle(plyPed, plyVehicle, -1)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 158) then -- Before right
					SetPedIntoVehicle(plyPed, plyVehicle, 0)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 160) then -- back left
					SetPedIntoVehicle(plyPed, plyVehicle, 1)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 164) then -- back left
					SetPedIntoVehicle(plyPed, plyVehicle, 2)
					Citizen.Wait(10)
				end
			end
		end
		Citizen.Wait(10) -- Fix Crash Client
	end
end)


-- REMOVE COPS PEDS

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
	local playerPed = GetPlayerPed(-1)
	local playerLocalisation = GetEntityCoords(playerPed)
	ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
	end
	end)

-- NO DROP PNJ 

function SetWeaponDrops()
    local handle, ped = FindFirstPed()
    local finished = false

    repeat
        if not IsEntityDead(ped) then
            SetPedDropsWeaponsWhenDead(ped, false)
        end
        finished, ped = FindNextPed(handle)
    until not finished

    EndFindPed(handle)
end

Citizen.CreateThread(function()
    while true do
        SetWeaponDrops()
        Citizen.Wait(500)
    end
end)


----- Disable CrossHair
 Citizen.CreateThread(function()
     local isSniper = false
     while true do
         Citizen.Wait(0)

         local ped = GetPlayerPed(-1)
         local currentWeaponHash = GetSelectedPedWeapon(ped)

         if currentWeaponHash == 100416529 then
             isSniper = true
         elseif currentWeaponHash == 205991906 then
             isSniper = true
         elseif currentWeaponHash == -952879014 then
             isSniper = true
         elseif currentWeaponHash == GetHashKey('WEAPON_HEAVYSNIPER_MK2') then
             isSniper = true
         else
             isSniper = false
         end

         if not isSniper then
             HideHudComponentThisFrame(14)
         end
     end
 end)

---------- disable pnj Carjacking

 Citizen.CreateThread(function()
     while true do
         Wait(800)

         local player = GetPlayerPed(-1)
         local PlayerPedId = PlayerPedId(player)

         local veh = GetVehiclePedIsTryingToEnter(PlayerPedId)
         if veh ~= nil and DoesEntityExist(veh) then

             local lockStatus = GetVehicleDoorLockStatus(veh)
             if lockStatus == 7 then
                 SetVehicleDoorsLocked(veh, 2)
             end

             local ped = GetPedInVehicleSeat(veh, -1)
             if ped then
                 SetPedCanBeDraggedOut(ped, false)
             end

         end
     end
 end)

-- ADD PVP

AddEventHandler("playerSpawned", function()
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)
end)

-- Remove cross kick

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
           DisableControlAction(1, 140, true)
              DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)

-- Disable dispatch & Weapon POLICE

Citizen.CreateThread(function()
	for i = 1, 12 do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
       
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local myCoords = GetEntityCoords(GetPlayerPed(-1))
        ClearAreaOfCops(myCoords.x, myCoords.y, myCoords.z, 100.0, 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)

Citizen.CreateThread(function()
    while true
        do
            -- 1.
        SetVehicleDensityMultiplierThisFrame(0.2)
        --SetPedDensityMultiplierThisFrame(0.2)
        --SetRandomVehicleDensityMultiplierThisFrame(1.0)
        --SetParkedVehicleDensityMultiplierThisFrame(1.0)
        --SetScenarioPedDensityMultiplierThisFrame(2.0, 2.0)
       
        --local playerPed = GetPlayerPed(-1)
        --local pos = GetEntityCoords(playerPed)
        --RemoveVehiclesFromGeneratorsInArea(pos['x'] - 900.0, pos['y'] - 900.0, pos['z'] - 900.0, pos['x'] + 900.0, pos['y'] + 900.0, pos['z'] + 900.0);
       
       
        -- 2.
        --SetGarbageTrucks(0)
        --SetRandomBoats(0)
        --SetRandomBus(0)
        Citizen.Wait(1)
    end
 
end)


ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

 RegisterCommand("discord",function()
 	discordapp()
 end)

 function discordapp()
 	ESX.ShowNotification("~g~Here is the discord link of the FFD : ~p~https://discord.gg/vzbjvdatzH")
 end

-- Function
function GetPed() return GetPlayerPed(-1) end
function GetCar() return GetVehiclePedIsIn(GetPlayerPed(-1),false) end


--------------- KNOCKOUT

local knockedOut = false
local wait = 15
local count = 60

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local myPed = GetPlayerPed(-1)
		if IsPedInMeleeCombat(myPed) then
			if GetEntityHealth(myPed) < 115 then
				SetPlayerInvincible(PlayerId(), true)
				SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
				ShowNotification("~r~You are knocked out!")
				wait = 15
				knockedOut = true
				SetEntityHealth(myPed, 116)
			end
		end
		if knockedOut == true then
			SetPlayerInvincible(PlayerId(), true)
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)
			
			if wait >= 0 then
				count = count - 1
				if count == 0 then
					count = 60
					wait = wait - 1
					SetEntityHealth(myPed, GetEntityHealth(myPed)+4)
				end
			else
				SetPlayerInvincible(PlayerId(), false)
				knockedOut = false
			end
		end
	end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

-- timertazer

local tiempo = 4000 -- 1000 ms = 1s
local isTaz = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if IsPedBeingStunned(GetPlayerPed(-1)) then
			
			SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
			
		end
		
		if IsPedBeingStunned(GetPlayerPed(-1)) and not isTaz then
			
			isTaz = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
			
		elseif not IsPedBeingStunned(GetPlayerPed(-1)) and isTaz then
			isTaz = false
			Wait(5000)
			
			SetTimecycleModifier("hud_def_desat_Trevor")
			
			Wait(10000)
			
      SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
		end
	end
end)