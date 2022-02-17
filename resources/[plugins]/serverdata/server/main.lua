local Server = GetConvar('sv_type', 'FA')
local Servers = {
	['DEV'] = {
		webhook = "",
		drugs = {
			WeedField = vector3(-124.086, 2791.240, 53.107),
			WeedProcessing = vector3(-1146.794, 4940.908, 222.26),
			WeedDealer = vector3(364.350, -2065.05, 21.74),
			CokeField = vector3(-106.441, 1910.979, 196.936),
			CokeProcessing = vector3(722.438, 4190.06, 41.09),
			CokeDealer = vector3(724.99, -1189.87, 24.27),
			MethField = vector3(2434.164, 4969.4897, 42.347),
			MethProcessing = vector3(1391.541, 3603.589, 38.941),
			MethDealer = vector3(-1146.794, 4940.908, 222.268),
			OpiumField = vector3(1444.35, 6332.3, 23.96),
			OpiumProcessing = vector3(2165.724, 3379.376, 46.43),
			OpiumDealer = vector3(3817.0505, 4441.494, 2.810)
		}
	},
	['FA'] = {
		webhook = "https://discord.com/api/webhooks/848945789573267516/XMmXm4RDaYO6UGFjD6RfEq-KttIABo8mdgmt0LjLd-1fmoYEPCdGFPgUaU1Urb6IftIc",
		drugs = {
			WeedField = vector3(164.13, 2284.91, 93.81),
			WeedProcessing = vector3(56.83, 3690.71, 39.92), --new
			WeedDealer = vector3(-1624.57, -1033.0, 5.94), --new
			CokeField = vector3(523.86, -1966.08, 26.55), --new
			CokeProcessing = vector3(-2170.32, 5197.43, 16.88), --new
			CokeDealer = vector3(3065.26, 2212.05, 3.41), --new
			MethField = vector3(1108.61, -1968.16, 31.01), --new
			MethProcessing = vector3(-709.98, -2527.35, 13.94), --neq
			MethDealer = vector3(731.19, 2530.91, 73.22), --new
			OpiumField = vector3(213.84, -1692.5, 29.31), --new
			OpiumProcessing = vector3(3823.12,4449.6, 4.42), --new
			OpiumDealer = vector3(-208.35, 3657.36, 51.75), --new
		}
	},
	['WL'] = {
		webhook = "",
		drugs = {
			WeedField = vector3(-2939.7504, 590.7938, 23.9843),
			WeedProcessing = vector3(9.1790, 52.8179, 71.6338),
			WeedDealer = vector3(37.2775, -1029.3741, 29.5688),
			CokeField = vector3(1222.5316, 1898.9322, 77.9426),
			CokeProcessing = vector3(8.7506, -243.1087, 55.8605),
			CokeDealer = vector3(-289.3043, -1080.6926, 23.0211),
			MethField = vector3(-1000.0, -1000.0, -1000.0),
			MethProcessing = vector3(-1000.0, -1000.0, -1000.0),
			MethDealer = vector3(-1000.0, -1000.0, -1000.0),
			OpiumField = vector3(-1000.0, -1000.0, -1000.0),
			OpiumProcessing = vector3(-1000.0, -1000.0, -1000.0),
			OpiumDealer = vector3(-1000.0, -1000.0, -1000.0)
		}
	}
}

exports('GetData', function(key)
	return Servers[Server][key]
end)