local inDelivery = false
local modeltodelete
local delete = false
local deliveryPoint = nil
local activeJob = nil
local timer = 0
local PromptGroupEndDelivery = GetRandomIntInRange(0, 0xffffff)
-----blips
Citizen.CreateThread( function()
	for _, info in pairs(Config.Jobs) do
		local blip = N_0x554d9d53f696d002(1664425300, info.startPoint.x, info.startPoint.y, info.startPoint.z)
		SetBlipSprite(blip, -243818172, 1)
		SetBlipScale(blip, 0.3)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, _U('blip', info.stationName))
	end
end)
--------------native alt key press---
local DeliverPrompt
local active = false
local pressed = false
local inStartArea = false

function SetupDeliverPrompt()
	local str = 'Start delivery job'
	DeliverPrompt = PromptRegisterBegin()
	PromptSetControlAction(DeliverPrompt, 0xE8342FF2)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(DeliverPrompt, str)
	PromptSetEnabled(DeliverPrompt, false)
	PromptSetVisible(DeliverPrompt, false)
	PromptSetHoldMode(DeliverPrompt, true)
	PromptRegisterEnd(DeliverPrompt)
end

function SetupEndDeliverPrompt()
	local str = "deliver delivery"
	EndDeliverPrompt = PromptRegisterBegin()
	PromptSetControlAction(EndDeliverPrompt, 0xD9D0E1C0)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(EndDeliverPrompt, str)
	PromptSetEnabled(EndDeliverPrompt, true)
	PromptSetVisible(EndDeliverPrompt, true)
	PromptSetStandardMode(EndDeliverPrompt, 1)
	PromptSetGroup(EndDeliverPrompt, PromptGroupEndDelivery)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C, EndDeliverPrompt, true)
	PromptRegisterEnd(EndDeliverPrompt)
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		if inStartArea then
			if not active then
				PromptSetEnabled(DeliverPrompt, true)
				PromptSetVisible(DeliverPrompt, true)
				active = true
			end
			if PromptHasHoldModeCompleted(DeliverPrompt) then
				PromptSetEnabled(DeliverPrompt, false)
				PromptSetVisible(DeliverPrompt, false)
				pressed = true
				active = false
				inStartArea = false
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread( function()
	SetupDeliverPrompt()
	while true do
		Citizen.Wait(500)
		local isInMarker
		for k, v in pairs(Config.Jobs) do
			local betweencoords = #(GetEntityCoords(PlayerPedId()).xy - v.startPoint.xy)
			isInMarker = betweencoords < 1.5
			if isInMarker then
				activeJob = v
				inStartArea = true
				break
			end
		end
		if not isInMarker and inStartArea then
			inStartArea = false
			if active then
				PromptSetEnabled(DeliverPrompt, false)
				PromptSetVisible(DeliverPrompt, false)
				active = false
				pressed = false
			end
		end
	end
end)

---job start
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		if activeJob and pressed and not inDelivery then
			DoScreenFadeOut(2000)
			ResetMission()
			timer = activeJob.timeLimit and activeJob.timeLimit or Config.TimeLimit
			RemoveBlip(deliveryPoint)
			deliveryPoint = N_0x554d9d53f696d002(1664425300, activeJob.endPoint.x, activeJob.endPoint.y, activeJob.endPoint.z)
			SetBlipSprite(deliveryPoint, -44057202, 1)
			Citizen.InvokeNative(0x9CB1A1623062F402, deliveryPoint, activeJob.destination)
			active = false
			pressed = false
			inDelivery = true
			PromptSetEnabled(DeliverPrompt, false)
			PromptSetVisible(DeliverPrompt, false)
			TriggerServerEvent('vorp_DeliveryJob:server:startJob', activeJob.stationName)
			wagon(activeJob.cartSpawn)
			DoScreenFadeIn(2000)
			TriggerEvent("vorp:TipBottom", _U('delivery_point', activeJob.destination), 10000)
			StartGpsMultiRoute(6, true, true)
			-- Add the points
			AddPointToGpsMultiRoute(activeJob.endPoint.x, activeJob.endPoint.y, activeJob.endPoint.z)

			-- Set the route to render
			SetGpsMultiRouteRender(true)
		end
	end
end)

---job finish
Citizen.CreateThread( function()
	SetupEndDeliverPrompt()
	while true do
		local sleep = true
		Citizen.Wait(0)
		if inDelivery and activeJob then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local b2 = #(coords.xy - activeJob.endPoint.xy)
			if b2 <= 10 then
				sleep = false
				local label = CreateVarString(10, 'LITERAL_STRING', 'Place of delivery reached on time')
            	PromptSetActiveGroupThisFrame(PromptGroupEndDelivery, label)
				if PromptHasStandardModeCompleted(EndDeliverPrompt) then
					if IsPedInAnyVehicle(playerPed, false) then
						local vehicle = GetVehiclePedIsIn(playerPed, false)
						local model = GetEntityModel(vehicle)
						TaskLeaveAnyVehicle(playerPed)
						Wait(8000)
						if model == -824257932 or model == -377157708 or model == 374792535 or model == -570691410 then
							TriggerServerEvent('vorp_DeliveryJob:server:payout', activeJob.payout.cash, activeJob.payout.gold, activeJob.payout.experience)
							TriggerEvent("vorp:TipBottom", _U('reward', activeJob.payout.cash, activeJob.payout.gold, activeJob.payout.experience), 4000)
							inDelivery = false
							RemoveBlip(deliveryPoint)
							deletewagon()
							SetGpsMultiRouteRender(false)
							TriggerServerEvent('vorp_DeliveryJob:server:endJob', activeJob.stationName)
							activeJob = nil
							DoScreenFadeIn(2000)
						else
							TriggerEvent("vorp:TipBottom", _U('wrong_car'), 4000)
						end
					else
						TriggerEvent("vorp:TipBottom", _U('go_on_vehicle'), 4000)
					end
				end
			end
		end
		if sleep then
			Wait(1000)
		end
	end
end)

Citizen.CreateThread( function()
	local playerPed = PlayerPedId()
	while true do
		Citizen.Wait(1000)
		if inDelivery and timer <= 0 then
			inDelivery = false
			TaskLeaveAnyVehicle(playerPed)
			Wait(5000)
			RemoveBlip(deliveryPoint)
			deliveryPoint = nil
			deletewagon()
			SetGpsMultiRouteRender(false)
			TriggerServerEvent('vorp_DeliveryJob:server:removecash', activeJob.removecash.removec, activeJob.removecash.removeg, activeJob.removecash.removexp)
			TriggerEvent("vorp:TipBottom", _U('failed_delivery', activeJob.removecash.removec, activeJob.removecash.removeg, activeJob.removecash.removexp), 8000)
		else
			timer = timer - 1000
		end
	end
end)

function deletewagon()
	local entity = modeltodelete
	NetworkRequestControlOfEntity(entity)
	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(entity) do
		Wait(100)
		timeout = timeout - 100
	end
	SetEntityAsMissionEntity(entity, true, true)
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))

	if (DoesEntityExist(entity)) then
		DeleteEntity(entity)
		modeltodelete = nil
	end
	modeltodelete = nil
end

function wagon(wag)
	local ped = PlayerPedId()
	local car_start = GetEntityCoords(ped)
	local car_random = { "CART01", "CART08", "CART04", "CART05" }
	local car_name = car_random[math.random(1,#car_random)]
	local carHash = GetHashKey(car_name)
	RequestModel(carHash)

	while not HasModelLoaded(carHash) do
		Citizen.Wait(0)
	end

	local car = CreateVehicle(carHash, wag.x, wag.y, wag.z, wag.w, true, false)
	SetVehicleOnGroundProperly(car)
	Wait(200)
	SetPedIntoVehicle(ped, car, -1)
	SetModelAsNoLongerNeeded(carHash)
	modeltodelete = car
end

-- prevents the native bugging if you restart script
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	RemoveBlip(deliveryPoint)
	deliveryPoint = nil
	SetGpsMultiRouteRender(false)
	if activeJob then
		TriggerServerEvent('vorp_DeliveryJob:server:endJob', activeJob.stationName)
		activeJob = nil
	end
end)

function ResetMission()
	RemoveBlip(deliveryPoint)
	deliveryPoint = nil
	SetGpsMultiRouteRender(false)
	inDelivery = false
	deletewagon()
	if activeJob then
		TriggerServerEvent('vorp_DeliveryJob:server:endJob', activeJob.stationName)
	end
end

keys = {
	-- Letters
	["A"] = 0x7065027D,
	["B"] = 0x4CC0E2FE,
	["C"] = 0x9959A6F0,
	["D"] = 0xB4E465B4,
	["E"] = 0xCEFD9220,
	["F"] = 0xB2F377E8,
	["G"] = 0x760A9C6F,
	["H"] = 0x24978A28,
	["I"] = 0xC1989F95,
	["J"] = 0xF3830D8E,
	-- Missing K, don't know if anything is actually bound to it
	["L"] = 0x80F28E95,
	["M"] = 0xE31C6A41,
	["N"] = 0x4BC9DABB,
	-- Push to talk key
	["O"] = 0xF1301666,
	["P"] = 0xD82E0BD2,
	["Q"] = 0xDE794E3E,
	["R"] = 0xE30CD707,
	["S"] = 0xD27782E3,
	-- Missing T
	["U"] = 0xD8F73058,
	["V"] = 0x7F8D09B8,
	["W"] = 0x8FD015D8,
	["X"] = 0x8CC9CD42,
	-- Missing Y
	["Z"] = 0x26E9DC00,

	-- Symbol Keys
	["RIGHTBRACKET"] = 0xA5BDCD3C,
	["LEFTBRACKET"] = 0x430593AA,
	-- Mouse buttons
	["MOUSE1"] = 0x07CE1E61,
	["MOUSE2"] = 0xF84FA74F,
	["MOUSE3"] = 0xCEE12B50,
	["MWUP"] = 0x3076E97C,
	-- Modifier Keys
	["CTRL"] = 0xDB096B85,
	["TAB"] = 0xB238FE0B,
	["SHIFT"] = 0x8FFC75D6,
	["SPACEBAR"] = 0xD9D0E1C0,
	["ENTER"] = 0xC7B5340A,
	["BACKSPACE"] = 0x156F7119,
	["LALT"] = 0x8AAA0AD4,
	["DEL"] = 0x4AF4D473,
	["PGUP"] = 0x446258B6,
	["PGDN"] = 0x3C3DD371,
	-- Function Keys
	["F1"] = 0xA8E3F467,
	["F4"] = 0x1F6D95E5,
	["F6"] = 0x3C0A40F2,
	-- Number Keys
	["1"] = 0xE6F612E4,
	["2"] = 0x1CE6D9EB,
	["3"] = 0x4F49CC4C,
	["4"] = 0x8F9F9E58,
	["5"] = 0xAB62E997,
	["6"] = 0xA1FDE2A6,
	["7"] = 0xB03A913B,
	["8"] = 0x42385422,
	-- Arrow Keys
	["DOWN"] = 0x05CA7C52,
	["UP"] = 0x6319DB71,
	["LEFT"] = 0xA65EBAB4,
	["RIGHT"] = 0xDEB34313,
}