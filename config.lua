Config = {}

Config.tintTable = {
    [-1] = 70, -- None
    [0] = 70, -- None
    [4] = 70, -- Stock
    [5] = 50, -- Limo
    [3] = 35, -- Light Smoke
    [6] = 20, -- Green 
    [2] = 10, -- Dark Smoke
    [1] = 5, -- Pure Black
}

Config.NIK = {
	Amphetamine = {
		'meth_baggie',
		'meth_packaged',
		'meth_brick',
		'meth_pure'
	},
	Cocaine = {
		'coke_packaged',
		'cocaine',
		'coke_brick',
		'coke_raw',
		'coca',
		'coca_mash',
		'crack_baggie',
		'crack_brick'
	},
	THC = {
		'joint',
		'weed_brick',
		'marijuana'
	},
	Opiate = {
		'heroin_baggie',
		'heroin_brick',
		'opium',
		'painkillers',
		'poppy'
	},
	Fentanyl = {
		'meth_baggief',
		'cocaine_packaged_f',
		'fentanyl'
	}
}

Config.Goggles = {
	['nightvision'] = {
		type = 'nvg',
		clothes = 119,
		switch = SetNightvision
	},
	['thermalvision'] = {
		type = 'thm',
		clothes = 148,
		switch = SetSeethrough
	},
	['gasmask'] = {
		type = 'gas',
		clothes = 46,
		switch = nil
	}
}