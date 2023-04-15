sharedCFG = {}

sharedCFG.debug = {["airdrop-fail"] = true, ["airdrop-captured"] = true, ["airdrop-spawn"] = true, ["airdrop-giveItems"] = true}
sharedCFG.spawnedEvent = "playerSpawned"
sharedCFG.timeToCaptureDrop = 10

sharedCFG.marker = {
    color = {
        r = 252,
        g = 28,
        b = 185
    }
}

sharedCFG.blip = {
    scale = 2.0,
    blipId = 251,
    colour = 50,
    name = "AirDrop"
}

sharedCFG.messages = {
    ["spawnAirDrop"] = "Nowy zrzut zostal zrzucony i zaznaczony na mapie",
    ["fail"] = "Przejmowanie zrzutu anulowane",
    ["success"] = "Zrzut zostal przejety",
    ["collect"] = "Kliknij E aby przejąć drop!",
    ["collecting"] = "Przejmowanie zrzutu poczekaj ",
    ["airdrop"] = "Zrzut"
}

sharedCFG.notify = function(obj)
    if not obj.tittle or not obj.msg then return end
	print(obj.tittle, obj.msg)
end