
-- Client Side pasted by Fineeasz
-- github.com/fineeasz

airdrops = {}
airdrops.models = {
	"ex_prop_crate_ammo_bc"
}
airdrops.blip = nil
airdrops.obj = nil
airdrops.coords = nil
airdrops.captured = true
airdrops.capturing = false
airdrops.defaultTime = sharedCFG.timeToCaptureDrop
airdrops.timer = sharedCFG.timeToCaptureDrop
airdrops.sp = false
airdrops.uniqueId = nil

AddEventHandler(sharedCFG.spawnedEvent, function()
	if not airdrops.sp then
		airdrops.sp = true
		TriggerServerEvent("FineeaszCORE:AirDrops_s", {arg = "get"})
	end
end)

airdrops.Draw3DText = function(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if airdrops.capturing then
			airdrops.timer = airdrops.timer - 1
			if airdrops.timer == 0 then
				TriggerServerEvent("FineeaszCORE:AirDrops_s", {arg = "capturedSuccess", uniqueId = airdrops.uniqueId})
			end
		end
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(airdrops.models) do
		RequestModel(v)
		while not HasModelLoaded(v) do
			Wait(0)
		end
	end
	ClearPedTasksImmediately(PlayerPedId())
	while true do
		Wait(1)
		if airdrops.capturing then
			if airdrops.coords then
				local coords = GetEntityCoords(PlayerPedId())
				local dist = math.sqrt((coords.x - airdrops.coords.x)^2 + (coords.y - airdrops.coords.y)^2 + (coords.z - airdrops.coords.z)^2)
                DrawMarker(1, airdrops.coords.x,airdrops.coords.y,airdrops.coords.z-1.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 12.0, 12.0, 2.0, sharedCFG.marker.color.r, sharedCFG.marker.color.g, sharedCFG.marker.color.b, 100, false, true, 2, false, nil, nil, false)
				if dist > 6 then
					airdrops.capturing = false
					TriggerServerEvent("FineeaszCORE:AirDrops_s", {arg = "capturedFail"})
					sharedCFG.notify({tittle = sharedCFG.messages["airdrop"], msg = sharedCFG.messages["fail"]})
				end
			end
			airdrops.Draw3DText(airdrops.coords.x,airdrops.coords.y,airdrops.coords.z, 1.0, sharedCFG.messages["collecting"].. airdrops.timer.. " sec")
		end
		if airdrops.coords then
			local coords = GetEntityCoords(PlayerPedId())
			local dist = math.sqrt((coords.x - airdrops.coords.x)^2 + (coords.y - airdrops.coords.y)^2 + (coords.z - airdrops.coords.z)^2)
			if dist < 30 then
				local ve = GetVehiclePedIsIn(PlayerPedId(), false)
				if ve then
					DeleteEntity(ve)
				end
			end
			if dist < 5 then
				if not airdrops.capturing and not airdrops.captured and GetEntityHealth(PlayerPedId()) ~= 0 then
					airdrops.Draw3DText(airdrops.coords.x,airdrops.coords.y,airdrops.coords.z, 2.0, sharedCFG.messages["collect"])
				end
				if IsControlJustPressed(0, 38) and not airdrops.capturing then
					airdrops.capturing = true
				end
			end
		end
	end
end, true)

airdrops.createBlips = function(x,y,z)
	airdrops.blip = AddBlipForCoord(x,y,z)
	SetBlipScale(airdrops.blip, sharedCFG.blip.scale)
	SetBlipSprite(airdrops.blip, sharedCFG.blip.blipId)
	SetBlipHighDetail(airdrops.blip, true)
	SetBlipColour(airdrops.blip, sharedCFG.blip.colour)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(sharedCFG.blip.name)
	EndTextCommandSetBlipName(airdrops.blip)
end

RegisterNetEvent('FineeaszCORE:AirDrops_c')
AddEventHandler('FineeaszCORE:AirDrops_c', function(obj)
	if not obj.arg then return end
	if obj.arg == "success" then 
		if not obj.owner then return end
		RemoveBlip(airdrops.blip)
		DeleteEntity(airdrops.obj)
		RemoveParticleFxInRange(0.0,0.0,0.0,9999.0)
		airdrops.capturing = false
		airdrops.coords = nil
		airdrops.captured = true
		airdrops.timer = airdrops.defaultTime
		sharedCFG.notify({tittle = sharedCFG.messages["airdrop"], msg = sharedCFG.messages["success"]})
	elseif obj.arg == "fail" then
		airdrops.capturing = false
		airdrops.timer = airdrops.defaultTime
		-- sharedCFG.notify({tittle = sharedCFG.messages["airdrop"], msg = sharedCFG.messages["fail"]})
	elseif obj.arg == "spawn" then
		if not obj.coords then return end
		if not obj.uniqueId then return end
		spawnAirDrop(obj.coords, obj.uniqueId)
	elseif obj.arg == "notify" then
		if not obj.tittle or not obj.msg then return end
		sharedCFG.notify(obj)
	end
end)

spawnAirDrop = function(spawn, uniqueId)
	RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
	while (not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@")) do Citizen.Wait(0) end
	airdrops.obj = CreateObject(GetHashKey("ex_prop_crate_ammo_bc"), spawn.x,spawn.y,spawn.z - 1.0, false,true,false)
	FreezeEntityPosition(airdrops.obj, true)
	sharedCFG.notify({tittle = sharedCFG.messages["airdrop"], msg = sharedCFG.messages["spawnAirDrop"]})
	airdrops.captured = false
	airdrops.coords = spawn
	airdrops.timer = airdrops.defaultTime
	airdrops.uniqueId = uniqueId
	airdrops.createBlips(spawn.x,spawn.y,spawn.z)
	if not HasNamedPtfxAssetLoaded("core") then
        RequestNamedPtfxAsset("core")
        while not HasNamedPtfxAssetLoaded("core") do
            Wait(10)
        end
    end
    UseParticleFxAssetNextCall("core")
    local xd = StartParticleFxLoopedAtCoord("proj_flare_fuse", spawn.x,spawn.y,spawn.z + 0.5, 0.0, 0.0, 0.0, 5.0, false, false, false, 0) 
	SetParticleFxLoopedColour(xd, 1.0, 0.0, 0.0, 0)
	SetParticleFxLoopedEvolution(xd, "core", 100, false)
end