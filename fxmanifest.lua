fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'General Shark'
description 'Collection of Police Utilities'
version '1.2.2'

dependencies { 'ox_lib'}

shared_scripts {'@ox_lib/init.lua','config.lua'}

server_scripts {
	'server.lua'
}

client_scripts {
	'client.lua'
}
