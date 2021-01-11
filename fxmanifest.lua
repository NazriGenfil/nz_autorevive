fx_version 'adamant'

game 'gta5'

author 'Ahmad Habibie Nazri | GIT#7153'

description 'Auto Revive System ketika ems tidak ada di kota'

client_scripts {
	'config.lua',
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua',
}

