fx_version 'adamant'

author 'ZeBee#0433'
game 'gta5'
version '1.0.0'



server_scripts {

	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'config.lua',
    'server/server.lua',

}



client_scripts {

    '@es_extended/locale.lua',
    'config.lua',
    'client/client.lua',
    'client/crouch.lua',
	'client/handsup.lua',
	'client/pointing.lua',

}

lua54 'yes'

escrow_ignore {
    'config.lua',
    'client/client.lua',
    'client/crouch.lua',
	'client/handsup.lua',
	'client/pointing.lua',

}