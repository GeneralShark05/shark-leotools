Config = {}

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
	['nvg'] = {
		item = 'nightvision',
		clothes = 119,
		switch = SetNightvision
	},
	['thm'] = {
		item = 'thermalvision',
		clothes = 148,
		switch = SetSeethrough
	},
	['gas'] = {
		item = 'gasmask',
		clothes = 46,
		switch = nil
	}
}

Config.goggConv = {
    ['nightvision'] = 'nvg',
    ['thermalvision'] = 'thm',
    ['gasmask'] = 'gas',
}