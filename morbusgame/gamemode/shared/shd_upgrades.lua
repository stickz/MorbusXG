/*------------------------------------------------
SO MANY UPGRADES BITCHES
-------------------------------------------------*/


UPGRADE = {} --To be used as ENUM
UPGRADES = {} -- Used to store upgrade data
UPGRADE_TREES = {} -- Used to store upgrade tree

-- I do it this way cause it looks nicer to me
UPGRADE_TREES[1] = "Offense"
UPGRADE_TREES[2] = "Defense"
UPGRADE_TREES[3] = "Utility"

-- The tree will be refrenced via number or enum
TREE_OFFENSE = 1
TREE_DEFENSE = 2
TREE_UTILITY = 3

-- The upgrades
-- Upgrade Icons created by: Demonkush
UPGRADE.CLAWS = 1
UPGRADE.CLAW_AMOUNT = 1
UPGRADES[1] = {
	Title="Sharp Claws",
	Tree=TREE_OFFENSE,
	Desc="Increases attack damage by "..UPGRADE.CLAW_AMOUNT.." per level",
	Icon= "vgui/morbus/brood/icon_brood_claws.png",
	MaxLevel=3,
	Tier=2
}


UPGRADE.CARAPACE = 2
UPGRADE.CARAPACE_AMOUNT = 4
UPGRADES[2] = {
	Title="Hardened Carapace",
	Tree=TREE_DEFENSE,
	Desc="Decreases damage taken by 16% ("..UPGRADE.CARAPACE_AMOUNT.."% per Level)",
	Icon="vgui/morbus/brood/icon_brood_carapace.png",
	MaxLevel=4,
	Tier=1
}


UPGRADE.SPRINT = 3
UPGRADE.SPRINT_AMOUNT = 22
UPGRADES[3] = {
	Title="Adrenaline Glands",
	Tree=TREE_UTILITY,
	Desc="Increases the speed of your sprint by "..UPGRADE.SPRINT_AMOUNT.." per level",
	Icon="vgui/morbus/brood/icon_brood_adrenaline.png",
	MaxLevel=4,
	Tier=1
}


UPGRADE.EXHAUST = 4
UPGRADE.EXHAUST_AMOUNT = 60
UPGRADES[4] = {
	Title="Exhuastion",
	Tree=TREE_OFFENSE,
	Desc="Decreases human time mission time by sixty seconds per swipe.",
	Icon="vgui/morbus/brood/icon_brood_exhaust.png",
	MaxLevel=1,
	Tier=1
}


UPGRADE.SDEFENSE = 5
UPGRADE.SDEFENSE_AMOUNT = 15
UPGRADES[5] = {
	Title="Enforced Scales",
	Tree=TREE_DEFENSE,
	Desc="Reduces damage from pistols and SMGs by "..UPGRADE.SDEFENSE_AMOUNT.."%",
	Icon="vgui/morbus/brood/icon_brood_scales.png",
	MaxLevel=1,
	Tier=2
}


UPGRADE.SCREAM = 6
UPGRADES[6] = {
	Title="Upgraded Screech",
	Tree=TREE_OFFENSE,
	Desc="When you transform into alien form, blinds and blurs nearby humans vision.",
	Icon="vgui/morbus/brood/icon_brood_screech.png",
	MaxLevel=1,
	Tier=1
}


UPGRADE.ATKSPEED = 7
UPGRADE.ATKSPEED_AMOUNT = 6
UPGRADES[7] = {
	Title="Relentless Attack",
	Tree=TREE_OFFENSE,
	Desc="Your attack speed increaes by "..UPGRADE.ATKSPEED_AMOUNT.."% per level",
	Icon="vgui/morbus/brood/icon_brood_relentless.png",
	MaxLevel=5,
	Tier=1
}


UPGRADE.REGEN = 8
UPGRADE.REGEN_AMOUNT = 2
UPGRADES[8] = {
	Title="Regenerative Tissue",
	Tree=TREE_DEFENSE,
	Desc="Restores "..UPGRADE.REGEN_AMOUNT.."*(LEVEL) health per second when in alien form",
	Icon="vgui/morbus/brood/icon_brood_regen2.png",
	MaxLevel=2,
	Tier=1
}


UPGRADE.LEGS = 9
UPGRADE.LEGS_AMOUNT = 160
UPGRADES[9] = {
	Title="Strengthened Legs",
	Tree=TREE_UTILITY,
	Desc="Increases jumping power and removes fall damage",
	Icon="vgui/morbus/brood/icon_brood_jump.png",
	MaxLevel=1,
	Tier=2
}


UPGRADE.LIFESTEAL = 10
UPGRADE.LIFESTEAL_AMOUNT = 3
UPGRADES[10] = {
	Title="Blood Thirst",
	Tree=TREE_OFFENSE,
	Desc="Regenerates "..UPGRADE.LIFESTEAL_AMOUNT.."*(LEVEL) HP everytime you attack a human",
	Icon="vgui/morbus/brood/icon_brood_blood.png",
	MaxLevel=3,
	Tier=2
}


UPGRADE.HDEFENSE = 11
UPGRADE.HDEFENSE_AMOUNT = 18
UPGRADES[11] = {
	Title="Enforced Skeleton",
	Tree=TREE_DEFENSE,
	Desc="Reduces damage from Rifles and Shotguns by "..UPGRADE.HDEFENSE_AMOUNT.."%",
	Icon="vgui/morbus/brood/icon_brood_enforced.png",
	MaxLevel=1,
	Tier=2
}


UPGRADE.BREATH = 12
UPGRADES[12] = {
	Title="Softened Breath",
	Tree=TREE_UTILITY,
	Desc="Mutes the sound of your breathing",
	Icon="vgui/morbus/brood/icon_brood_mute.png",
	MaxLevel=1,
	Tier=2
}


UPGRADE.SMELLRANGE = 13
UPGRADE.SMELLRANGE_AMOUNT = 1500
UPGRADES[13] = {
	Title="Enhanced Smell",
	Tree=TREE_OFFENSE,
	Desc="Significantly increases the range from which you can smell humans.",
	Icon="vgui/morbus/brood/icon_brood_smell.png",
	MaxLevel=1,
	Tier=2
}


UPGRADE.HEALTH = 14
UPGRADE.HEALTH_AMOUNT = 15
UPGRADES[14] = {
	Title="Endurance",
	Tree=TREE_DEFENSE,
	Desc="Increases maximum health by "..UPGRADE.HEALTH_AMOUNT.." per level",
	Icon="vgui/morbus/brood/icon_brood_regen.png",
	MaxLevel=5,
	Tier=2
}


UPGRADE.INVISIBLE = 15
UPGRADE.INVISIBLE_AMOUNT = 4
UPGRADES[15] = {
	Title="Adaptive Carapace",
	Tree=TREE_UTILITY,
	Desc="You become invisible when staying still for 16 - (4 * level) seconds.",
	Icon="vgui/morbus/brood/icon_brood_question.png",
	MaxLevel=3,
	Tier=1
}