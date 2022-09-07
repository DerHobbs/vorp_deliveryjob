local VorpCore = { }

TriggerEvent("getCore", function(core)
	VorpCore = core
end )

local onJob = { }

RegisterNetEvent("vorp_DeliveryJob:server:startJob")
AddEventHandler("vorp_DeliveryJob:server:startJob", function(job)
	if not onJob[source] then
		onJob[source] = job
	end
end )

RegisterNetEvent("vorp_DeliveryJob:server:endJob")
AddEventHandler("vorp_DeliveryJob:server:endJob", function()
	if onJob[source] then
		onJob[source] = nil
	end

end )

RegisterNetEvent("vorp_DeliveryJob:server:payout")
AddEventHandler("vorp_DeliveryJob:server:payout", function(cash, gold, xp)
	if onJob[source] then
		local Character = VorpCore.getUser(source).getUsedCharacter
		Character.addCurrency(0, cash)
		Character.addCurrency(1, gold)
		Character.addXp(xp)
	end
end )

RegisterNetEvent("vorp_DeliveryJob:server:removecash")
AddEventHandler("vorp_DeliveryJob:server:removecash", function(cash, gold, xp)
	if onJob[source] then
		local Character = VorpCore.getUser(source).getUsedCharacter
		Character.removeCurrency(0, cash)
		Character.removeCurrency(1, gold)
		Character.removeCurrency(xp)
	end
end )