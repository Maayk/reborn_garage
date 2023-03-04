fx_version 'cerulean'
game 'gta5'

ui_page "main/index.html"

files {
    "main/*.html",
    "main/img/*.png",
    "main/*.css",
    "main/*.js",
}

client_scripts {
    'client/main.lua',
    'client/gui.lua',
    'SharedConfig.lua',
}

server_scripts {
    'server/main.lua',
    'SharedConfig.lua',
}