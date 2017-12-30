-- SwarmShop v2 -- Public Release --
-- Created by Demonkush -- www.xmpstudios.com -- 

SwarmShop = {}
SwarmShop.Abilities = {}
SwarmShop.Abilities[1] = { 	id = 0, 	price = 0, 		name = "Default Spit", 		desc = "Reset spit attack.", 									icon = "icon_normal"}
SwarmShop.Abilities[2] = { 	id = 7, 	price = 1, 		name = "Unstable Bore", 	desc = "Timed bouncy bomb.", 									icon = "icon_unstablebore"}
SwarmShop.Abilities[3] = { 	id = 1, 	price = 2, 		name = "Chemical Bomb", 	desc = "Incendiary spit.", 										icon = "icon_chemicalbomb"}
SwarmShop.Abilities[4] = { 	id = 5, 	price = 3, 		name = "Swarm Haste", 		desc = "1.5x faster Swarm \nspeed.", 							icon = "icon_swarmhaste"}
SwarmShop.Abilities[5] = { id = 10, 	price = 3, 		name = "Leap", 				desc = "A hardy leap to get \nup high places.", 				icon = "icon_leap"}
SwarmShop.Abilities[6] = { 	id = 2, 	price = 4, 		name = "Nitro Core", 		desc = "Weaker attack but \nslows humans on \ncontact.", 		icon = "icon_nitrocore"}
SwarmShop.Abilities[7] = { 	id = 3, 	price = 5, 		name = "Shock Spit", 		desc = "Electric spit with a \nlarger radius of \ndamage.", 	icon = "icon_shockspit"}
SwarmShop.Abilities[8] = { 	id = 9, 	price = 5, 		name = "Spikes", 			desc = "Launches a shotgun \nof spikes.", 						icon = "icon_spikes"}
SwarmShop.Abilities[9] = { 	id = 8, 	price = 6, 		name = "Remote Charge", 	desc = "Sticky remote \ndetonated spit ball. \n\nHit reload to \ndetonate.", 				icon = "icon_remotespit"}
SwarmShop.Abilities[10] = { id = 12, 	price = 6, 		name = "Acid Sac", 			desc = "Spit releases acid \non impact, damaging \nnearby humans.", 						icon = "icon_acidspit"}
SwarmShop.Abilities[11] = { id = 11, 	price = 7, 		name = "Self Destruct", 	desc = "3 second \nself-detonation \nthat deals massive \ndamage to enemies \naround you.", icon = "icon_selfdestruct"}
SwarmShop.Abilities[12] = { id = 13, 	price = 8, 		name = "Magma Clot", 		desc = "Sticky cluster fire \nbomb.", 														icon = "icon_magmaclot"}
--SwarmShop.Abilities[8] = { 	id = 6, 	price = 5, 		name = "Blood Siphon", 		desc = "Steals HP.", 																	icon = "icon_bloodsiphon"}

SwarmShop.SuddenDeathRounds		= 0 	-- Number of rounds from the last round ( including last round ) to discount swarm shop items for everyone.
SwarmShop.FinalRoundDiscount 	= 0.5 	-- ( 0-1 ) Discount decimal ( percentage ) on swarm shop items during the configured sudden death period.
-- If both are set to 0, this feature will be disabled.

SwarmShop.VIPDiscount 			= 0 	-- ( 0-1 ) Discount decimal ( percentage ) for VIPs
SwarmShop.AdminDiscount 		= 0 	-- ( 0-1 ) Discount percent for admins, does not function if 0.

SwarmShop.RefundMultiplier 		= 0.51 	-- ( 0-1 ) Decimal ( percentage ) of how much money you recieve back from refunds. 1 = full refund, = 0 no refunds.

-- If any set to 0, those multipliers will be disabled.
-- VIP and Admin discounts are based off of IsUserGroup() and a table of whitelisted group names. Depending on your admin mod, you may need to make manual adjustments.