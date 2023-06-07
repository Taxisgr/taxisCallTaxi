ESX = nil
ESX = exports["es_extended"]:getSharedObject()
commandCooldown = false 
commandCooldownTime = Config.CommandCooldownTime * 1000
vehicle = nil
driver = nil
done = false
flag = false 

function CallTaxi() 
    if commandCooldown then
		ESX.ShowNotification("Command is on cooldown. Please wait.")
		return
	end
    
    if Config.CanCallInsideVehicle == false then
		-- Check if the player is already in a vehicle,  If the player is in a vehicle, then notify them and cancel
		if IsPedInAnyVehicle(PlayerPedId()) then
			ESX.ShowNotification("You are inside a vehicle, please get out in order to call a taxi!")
			return
		end
	end

	if not DoesEntityExist(vehicle) then -- If the player has already called a taxi, then notify them and cancel
            
            
            TriggerServerEvent("taxisCallTaxi:pay")
            RegisterNetEvent('taxisCallTaxi:isok')
            AddEventHandler('taxisCallTaxi:isok', function(payed)
                if not payed then
                    ESX.ShowNotification("You don't have enough money to pay the taxi. Money Needed: ".. Config.Price.. " from ".. Config.PriceType .. " account")
                    flag = true -- Set the flag to true to stop code execution
                else 
                    flag = false
                end
            end)
            
            Wait(1000)
            if flag then
                return -- Stop code execution if the flag is true
            end

            commandCooldown = true
	        SetTimeout(commandCooldownTime, function()
                commandCooldown = false
            end)
            
            RequestModel(Config.CarSpawnName)
			while not HasModelLoaded(Config.CarSpawnName) do
				Wait(0)
			end

            ESX.ShowNotification("You have successfully called a taxi!")
           

			-- Get player coordinates and then spawn the taxi next to them
            Wait(Config.WaitTime * 1000)
			local PlayerCoords = GetEntityCoords(PlayerPedId())
			local found, random_pos, heading = GetClosestVehicleNodeWithHeading(PlayerCoords.x - math.random(-1, Config.MaxDistance), PlayerCoords.y - math.random(-1, Config.MaxDistance), PlayerCoords.z, 12, 3.0, 0)
			vehicle = CreateVehicle(Config.CarSpawnName, random_pos, outHeading, true, false)

			-- Request Ped Model (Npc Driver) from the config
			local Model = Config.NPCModel
			if DoesEntityExist(vehicle) then
				RequestModel(Model)
				while not HasModelLoaded(Model) do
					Wait(0)
				end

				-- Create the ped inside the car
				driver = CreatePedInsideVehicle(vehicle, 26, Model, -1, true, false)
				SetModelAsNoLongerNeeded(vehicle)

				SetBlockingOfNonTemporaryEvents(driver, true)
				SetEntityAsMissionEntity(driver, true, true)
				SetEntityInvincible(driver, true)
			end

			SetVehicleOnGroundProperly(vehicle)
			SetEntityAsMissionEntity(vehicle, true, true)
			SetVehicleEngineOn(vehicle, true, true, false)

			SetDriveTaskDrivingStyle(driver, 1074528293)
			TaskVehicleDriveToCoord(driver, vehicle, PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 26.0, 0, Config.CarSpawnName, 411, 10.0)
			SetPedKeepTask(driver, true)

			ESX.ShowNotification("Your taxi will be here in the next few seconds")

			while #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 7.0 do
				Wait(200)
			end

			-- Delete
			local PlayerCoords = GetEntityCoords(PlayerPedId())
			local RandomCoords = vector3(PlayerCoords.x - math.random(-80, 80), PlayerCoords.y - math.random(-80, 80), PlayerCoords.z)

			TaskLeaveVehicle(driver, vehicle, 1)

			SetEntityAsMissionEntity(vehicle, false, false)
			SetEntityAsMissionEntity(driver, false, false)
			SetPedKeepTask(driver, false)

			TaskWanderStandard(driver, 10.0, 10)
			Wait(5000)
			DeletePed(driver)
			DeleteEntity(driver)
			driver = nil

            if Config.DeleteTaxi then
			while true do
				if GetVehiclePedIsIn(PlayerPedId(), false) == vehicle then
					while GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() do
						Wait(100)
					end
					Wait(Config.DeleteTaxiAfterTime * 1000)
					DeleteEntity(vehicle)
					break
				end
				Wait(100)
			end
            end
        else
            ESX.ShowNotification("Your taxi is already here/coming")
        end
end

RegisterCommand(Config.CommandName, function()
	CallTaxi()
end)
