fx_version 'cerulean'
game 'gta5'

author 'Moxy https://discord.gg/tJ8y4rXjcd / https://moxydev.xyz/'
description 'Clean Notifications System by moxy :D'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

ui_page 'web/build/index.html'

files {
    'web/build/static/css/*.css',
    'web/build/static/js/*.js',
    'web/build/index.html'
}
