-- If you using ESX use that 
-- ESX = nil
-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

serverCFG = {}

serverCFG.spawnLocations = {
    {2760.320801, 3468.240479, 55.689667},
    {2763.757812, 3476.289551, 55.554043},
    {2755.769531, 3458.425537, 55.865364}
}

serverCFG.items = {
    {name = "carchest", count = 5},
    {name = "kodNaVip3d", count = 1},
    {name = "bread", count = 8}
}

serverCFG.giveItems = function(obj)
    if not obj.src then return end
    local src = obj.src


    for k,v in pairs(serverCFG.items) do
        -- If you using ESX use that 
        -- local xPlayer = ESX.GetPlayerFromId(src)
        -- xPlayer.addInventoryItem(v.name, v.count)
        
        print("Gived Item: ".. v.name .."Count: ".. v.count .."")

    end

    TriggerClientEvent("FineeaszCORE:AirDrops_c", src, {arg = "notify", tittle = "Zrzut", msg = "Udalo ci sie przejac zrzut"})
    log({tittle = "airdrop-giveItems", msg = GetPlayerName(src).. " dostal itemy za przejecie zrzutu"})
end

-- You can do your own logic here

RegisterCommand("airdrop", function(source, args, rawCommand)
    local admin = true
    if admin then 
        createNewAirdrop({src = source})
    end
end)
