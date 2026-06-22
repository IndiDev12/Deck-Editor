# CardTextureMaps.gd

class_name CardTextureMaps
extends RefCounted


#
# Attributes
#

static var ATTRIBUTE_TEXTURES := {

	"EARTH": preload("res://assets/themes/default/textures/attributes/earth.png"),
	"WATER": preload("res://assets/themes/default/textures/attributes/water.png"),
	"FIRE": preload("res://assets/themes/default/textures/attributes/fire.png"),
	"WIND": preload("res://assets/themes/default/textures/attributes/wind.png"),
	"LIGHT": preload("res://assets/themes/default/textures/attributes/light.png"),
	"DARK": preload("res://assets/themes/default/textures/attributes/dark.png"),
	"DIVINE": preload("res://assets/themes/default/textures/attributes/divine.png"),

	"SPELL": preload("res://assets/themes/default/textures/attributes/spell.png"),
	"TRAP": preload("res://assets/themes/default/textures/attributes/trap.png")

}


#
# Races
#

static var RACE_TEXTURES := {

	"WARRIOR": preload("res://assets/themes/default/textures/monster_types/warrior.png"),
	"SPELLCASTER": preload("res://assets/themes/default/textures/monster_types/spellcaster.png"),
	"FAIRY": preload("res://assets/themes/default/textures/monster_types/fairy.png"),
	"FIEND": preload("res://assets/themes/default/textures/monster_types/fiend.png"),
	"ZOMBIE": preload("res://assets/themes/default/textures/monster_types/zombie.png"),
	"MACHINE": preload("res://assets/themes/default/textures/monster_types/machine.png"),
	"AQUA": preload("res://assets/themes/default/textures/monster_types/aqua.png"),
	"PYRO": preload("res://assets/themes/default/textures/monster_types/pyro.png"),
	"ROCK": preload("res://assets/themes/default/textures/monster_types/rock.png"),
	"WINGED_BEAST": preload("res://assets/themes/default/textures/monster_types/winged-beast.png"),
	"PLANT": preload("res://assets/themes/default/textures/monster_types/plant.png"),
	"INSECT": preload("res://assets/themes/default/textures/monster_types/insect.png"),
	"THUNDER": preload("res://assets/themes/default/textures/monster_types/thunder.png"),
	"DRAGON": preload("res://assets/themes/default/textures/monster_types/dragon.png"),
	"BEAST": preload("res://assets/themes/default/textures/monster_types/beast.png"),
	"BEAST_WARRIOR": preload("res://assets/themes/default/textures/monster_types/beast-warrior.png"),
	"DINOSAUR": preload("res://assets/themes/default/textures/monster_types/dinosaur.png"),
	"FISH": preload("res://assets/themes/default/textures/monster_types/fish.png"),
	"SEA_SERPENT": preload("res://assets/themes/default/textures/monster_types/sea-serpent.png"),
	"REPTILE": preload("res://assets/themes/default/textures/monster_types/reptile.png"),
	"PSYCHIC": preload("res://assets/themes/default/textures/monster_types/psychic.png"),
	"DIVINE_BEAST": preload("res://assets/themes/default/textures/monster_types/divine-beast.png"),
	"DIVINER_BEAST": preload("res://assets/themes/default/textures/monster_types/diviner-beast.png"),
	"WYRM": preload("res://assets/themes/default/textures/monster_types/wyrm.png"),
	"CYBERSE": preload("res://assets/themes/default/textures/monster_types/cyberse.png"),
	"ILLUSION": preload("res://assets/themes/default/textures/monster_types/illusion.png")

}


#
# Rating icons
#

static var LEVEL_TEXTURE := preload(
    "res://assets/themes/default/textures/level_rank_pendulum_links/level.png"
)

static var RANK_TEXTURE := preload(
    "res://assets/themes/default/textures/level_rank_pendulum_links/rank.png"
)

static var PENDULUM_TEXTURE := preload(
    "res://assets/themes/default/textures/level_rank_pendulum_links/pendulum_scale.png"
)


#
# Link arrows
#

static var LINK_ARROW_TEXTURES := {

	"tl": preload("res://assets/themes/default/textures/level_rank_pendulum_links/tl.png"),
	"t": preload("res://assets/themes/default/textures/level_rank_pendulum_links/t.png"),
	"tr": preload("res://assets/themes/default/textures/level_rank_pendulum_links/tr.png"),

	"l": preload("res://assets/themes/default/textures/level_rank_pendulum_links/l.png"),
	"r": preload("res://assets/themes/default/textures/level_rank_pendulum_links/r.png"),

	"bl": preload("res://assets/themes/default/textures/level_rank_pendulum_links/bl.png"),
	"b": preload("res://assets/themes/default/textures/level_rank_pendulum_links/b.png"),
	"br": preload("res://assets/themes/default/textures/level_rank_pendulum_links/br.png")

}
