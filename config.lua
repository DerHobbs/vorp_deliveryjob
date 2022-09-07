Config = { }

-- Language
Config.Locale = "en"

-- Blips
Config.MainSprite = 486881925 -- Job Blip sprite
Config.DeliverySprite = -570710357 -- Point Sprite
Config.ShowBlips = true -- Show Point blips

-- Timer and zone size
Config.ZoneSize = 2.0 -- Sizes of the zones
Config.TimeLimit = 800000

Config.Jobs = {
	-- Valentine to Bacchus Station
	{
		stationName = "Valentine Station.",
		destination = "Bacchus Station.",
		startPoint = vector3(-177.862,647.063,113.584),
		endPoint = vector3(570.52,1676.26,186.48),
		cartSpawn = vector4(-179.88,653.84,113.67,69.1),
		timeLimit = 600000,
		payout =
		{
			cash = 2.30,
			gold = 0,
			experience = 0,
		},
		removecash =
		{
			removec = 1.15,
			removeg = 0,
			removeexp = 0,
		}
	},
	-- Annesburg to Emerald Ranch
	{
		stationName = "Annesburg Station.",
		destination = "Emerald Ranch.",
		startPoint = vector3(2935.87,1277.88,44.85),
		endPoint = vector3(1420.15,383.93,90.33),
		cartSpawn = vector4(2923.16,1291.9,44.39,154.38),
		timeLimit = 600000,
		payout =
		{
			cash = 3.30,
			gold = 0,
			experience = 0,
		},
		removecash =
		{
			removec = 1.65,
			removeg = 0,
			removeexp = 0,
		}
	},
	--Blackwater to Strawberry
	{
		stationName = "Blackwater Station.",
		destination = "Strawberry Station.",
		startPoint = vector3(-756.55,-1322.81,43.71),
		endPoint = vector3(-1772.52,-385.93,156.76),
		cartSpawn = vector4(-751.02,-1323.17,43.3,179.77),
		timeLimit = 600000,
		payout =
		{
			cash = 2.70,
			gold = 0,
			experience = 0,

		},
		removecash =
		{
			removec = 1.35,
			removeg = 0,
			removeexp = 0,
		}
	},
	--MacFarland Ranch to Armadillo
	{
		stationName = "MacFarland Ranch.",
		destination = "Armadillo Station.",
		startPoint = vector3(-2324.89,-2406.17,63.85),
		endPoint = vector3(-3722.79,-2621.77,-13.34),
		cartSpawn = vector4(-2342.75,-2396.24,62.37,140.24),
		timeLimit = 600000,
		payout =
		{
			cash = 2.60,
			gold = 0,
			experience = 0,
		},
		removecash =
		{
			removec = 1.30,
			removeg = 0,
			removeexp = 0,
		}
	},
	-- Strawberry to Saint Denis
	{
		stationName = "Strawberry Station.",
		destination = "St. Denis Generalstore.",
		startPoint = vector3(-1820.58,-428.23,160.19),
		endPoint = vector3(2817.73,-1306.98,46.87),
		cartSpawn = vector4(-1832.23,-425.27,160.63,169.04),
		timeLimit = 1000000,
		payout =
		{
			cash = 5.90,
			gold = 0,
			experience = 0,
		},
		removecash =
		{
			removec = 2.80,
			removeg = 0,
			removeexp = 0,
		}
	},
	--Saint Denis to Van Horn !
	{
		stationName = "St. Denis Station.",
		destination = "Van Horn Station.",
		startPoint = vector3(2731.59,-1402.39,46.18),
		endPoint = vector3(2967.07,573.59,-44.55),
		cartSpawn = vector4(2732.65,-1414.17,45.15,113.52),
		timeLimit = 600000,
		payout =
		{
			cash = 2.90,
			gold = 0,
			experience = 0,
		},
		removecash =
		{
			removec = 1.45,
			removeg = 0,
			removeexp = 0,
		}
	},
	--Rhodes Train Station to Blackwater Construction
	{
		stationName = "Rhodes Train Station.",
		destination = "Blackwater Construction.",
		startPoint = vector3(1231.27,-1299.57,77.39),
		endPoint = vector3(-883.62,-1300.45,43.30),
		cartSpawn = vector4(1233.86,-1269.87,75.51,-35.92),
		timeLimit = 800000,
		payout =
		{
			cash = 4.90,
			gold = 0,
			experience = 0,
		},
		removecash =
		{
			removec = 2.45,
			removeg = 0,
			removeexp = 0,
		}
	},
}
