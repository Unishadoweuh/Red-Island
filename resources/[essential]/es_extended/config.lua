Config = {}
Config.Locale = 'fr'

Config.DefaultGroup = 'user'
Config.DefaultLevel = '0'
Config.CommandPrefix = '/'
Config.DefaultPosition = vector3(389.74, -355.99, 48.02)

Config.Accounts = {
	['cash'] = {
		label = _U('cash'),
		starting = 5000,
		priority = 1
	},
	['dirtycash'] = {
		label = _U('dirtycash'),
		starting = 0,
		priority = 2
	},
	['bank'] = {
		label = _U('bank'),
		starting = 25000,
		priority = 3
	},
	['chip'] = {
		label = 'Jetons Casino',
		starting = 0,
		priority = 4
	}
}

Config.EnableSocietyPayouts = true
Config.PaycheckInterval = 30 * 60 * 1000
Config.MaxWeight = 24