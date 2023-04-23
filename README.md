# shark-cops
A collection of various items, tools, and utilities for your police!

## LICENSE
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.

## Dependencies:
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)

Add the following to your data/items.lua in ox_inventory

	['nikkit'] = {
		label = 'NIK Kit',
		weight = 10,
		stack = true,
		close = true
	},

	['usednikkit'] = {
		label = 'Used NIK Kit',
		weight = 10,
		stack = true,
		close = true
	},

	['nightvision'] = {
		label = 'Nightvision Goggles',
		weight = 1000,
		stack = false,
		client = {
			event = exports('sharkcops-vision', 'nvg')
		}
	},

	['thermalvision'] = {
		label = 'FLIR Goggles',
		weight = 1000,
		stack = false,
		client = {
			event = exports('sharkcops-vision', 'thm')
		}
	},

	['gasmask'] = {
		label = 'CBRN Mask',
		weight = 1000,
		stack = false,
		client = {
			event = exports('sharkcops-vision', 'gas')
		}
	},
	
[Support - Discord](https://discord.gg/mFnNTV2Zce)
