if Config.USEESX then
 	ESX = exports["es_extended"]:getSharedObject()
else
	QBCore = exports['qb-core']:GetCoreObject()
end

commandCooldown = false 
commandCooldownTime = Config.CommandCooldownTime * 1000
vehicle = nil
driver = nil
done = false
flag = false 

function CallTaxi() 
    if commandCooldown then
		if Config.USEESX then
		ESX.ShowNotification("Command is on cooldown. Please wait.")
		else
		QBCore.Functions.Notify("Command is on cooldown. Please wait.")
		end
		return
	end
    
    if Config.CanCallInsideVehicle == false then
		-- Check if the player is already in a vehicle,  If the player is in a vehicle, then notify them and cancel
		if IsPedInAnyVehicle(PlayerPedId()) then
			if Config.USEESX then
			ESX.ShowNotification("You are inside a vehicle, please get out in order to call a taxi!")
			else
			QBCore.Functions.Notify("You are inside a vehicle, please get out in order to call a taxi!")
			return
		end
	end

	if not DoesEntityExist(vehicle) then -- If the player has already called a taxi, then notify them and cancel
            
            
            TriggerServerEvent("taxisCallTaxi:pay")
            RegisterNetEvent('taxisCallTaxi:isok')
            AddEventHandler('taxisCallTaxi:isok', function(payed)
                if not payed then
					if Config.USEESX then
                    ESX.ShowNotification("You don't have enough money to pay the taxi. Money Needed: ".. Config.Price.. " from ".. Config.PriceType .. " account")
                    flag = true -- Set the flag to true to stop code execution
					else
					QBCore.Functions.Notify("You don't have enough money to pay the taxi. Money Needed: ".. Config.Price.. " from ".. Config.PriceType .. " account")
					flag = true
					end
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

			if Config.USEESX then
            ESX.ShowNotification("You have successfully called a taxi!")
			else
			QBCore.Functions.Notify("You have successfully called a taxi!")
			end

			-- Get player coordinates and then spawn the taxi next to them
            Wait(Config.WaitTime * 1000)
			local pCoords = GetEntityCoords(PlayerPedId())
			local f, rp, heading = GetClosestVehicleNodeWithHeading(pCoords.x - math.random(-1, Config.MaxDistance), pCoords.y - math.random(-1, Config.MaxDistance), pCoords.z, 12, 3.0, 0)
			vehicle = CreateVehicle(Config.CarSpawnName, rp, outHeading, true, false)

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
			TaskVehicleDriveToCoord(driver, vehicle, pCoords.x, pCoords.y, pCoords.z, 26.0, 0, Config.CarSpawnName, 411, 10.0)
			SetPedKeepTask(driver, true)
			
			if Config.USEESX then
			ESX.ShowNotification("Your taxi will be here in the next few seconds")
			else 
			QBCore.Functions.Notify("Your taxi will be here in the next few seconds")
			end

			while #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 10.0 do
				Wait(500)
			end

			-- Delete
		
			TaskLeaveVehicle(driver, vehicle, 1)
			SetEntityAsMissionEntity(driver, false, false)
			SetEntityAsMissionEntity(vehicle, false, false)
			SetPedKeepTask(driver, false)
			TaskWanderStandard(driver, 10.0, 10)
			Wait(6000)
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
			if Config.USEESX then
            ESX.ShowNotification("Your taxi is already here/coming")
			else 
			QBCore.Functions.Notify("Your taxi is already here/coming")
        end
end

RegisterCommand(Config.CommandName, function()
	CallTaxi()
end)
