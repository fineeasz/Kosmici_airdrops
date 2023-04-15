fx_version "bodacious"
games {"gta5"}
author 'Fineeasz'
lua54 'yes'

client_scripts {
    'src/client.lua'
}

server_scripts {
    'cfg/servercfg.lua',
    'src/server.lua'
}

shared_scripts {
    'cfg/sharedcfg.lua'
}

escrow_ignore {
    'cfg/sharedcfg.lua',
    'cfg/servercfg.lua'
}
