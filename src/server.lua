-- Server Side created by Fineeasz
-- github.com/fineeasz

AirDrops = {}

function log(obj)
    if not obj.title or not obj.msg then return end
    if not sharedCFG.debug[obj.title] then return end
    print("(#DEBUG-".. obj.title ..") ".. obj.msg)
end

function capturedSuccess(obj)
    local src = obj.src
    local uniqueId = obj.uniqueId
    local ownerName = GetPlayerName(src)

    for i, airdrop in ipairs(AirDrops) do
        if airdrop.uniqueId == uniqueId then
            log({title = "airdrop-captured", msg = ownerName .. " captured airdrop (".. uniqueId ..")"})
            TriggerClientEvent("FineeaszCORE:AirDrops_c", -1, {arg = "success", owner = ownerName})
            table.remove(AirDrops, i)
            serverCFG.giveItems({src = src})
        end
    end
end

function createNewAirdrop(obj)
    local src = obj.src
    if #AirDrops >= 1 then
        log({title = "airdrop-limit", msg = GetPlayerName(src) .. " There is limit on airdrops"})
        return
    end

    local randomId = math.random(11111, 99999)
    local randomAirDropSpawn = serverCFG.spawnLocations[math.random(#serverCFG.spawnLocations)]

    log({title = "airdrop-spawn", msg = GetPlayerName(src) .. " spawned an airdrop"})

    table.insert(AirDrops, {uniqueId = randomId, coords = {x=randomAirDropSpawn[1], y=randomAirDropSpawn[2], z=randomAirDropSpawn[3]}})
    TriggerClientEvent("FineeaszCORE:AirDrops_c", -1, {arg = "spawn", coords = {x=randomAirDropSpawn[1], y=randomAirDropSpawn[2], z=randomAirDropSpawn[3]}, uniqueId = randomId})
end

RegisterNetEvent("FineeaszCORE:AirDrops_s")
AddEventHandler("FineeaszCORE:AirDrops_s", function(obj)
    local src = source
    if not obj.arg then return end

    if obj.arg == "get" then
        for _, airdrop in ipairs(AirDrops) do
            if airdrop.coords then
                local coords = airdrop.coords
                TriggerClientEvent("FineeaszCORE:AirDrops_c", -1, {arg = "spawn", coords = {x=coords.x, y=coords.y, z=coords.z}, uniqueId = airdrop.uniqueId})
            end
        end
    elseif obj.arg == "capturedSuccess" then
        capturedSuccess({src = src, uniqueId = obj.uniqueId})
    elseif obj.arg == "capturedFail" then
        log({title = "airdrop-fail", msg = GetPlayerName(src) .. " failed to capture the airdrop"})
        TriggerClientEvent("FineeaszCORE:AirDrops_c", src, {arg = "fail"})
    end
end)
