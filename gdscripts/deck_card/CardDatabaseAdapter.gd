# CardDatabaseAdapter.gd

class_name CardDatabaseAdapter
extends RefCounted


static func from_database(card:Dictionary) -> Dictionary:

	var result := {}


	#
	# Basic
	#

	result.id = card.id
	result.name = card.name
	result.type = card.type

	result.atk = card.atk
	result.def = card.def
	result.level = card.level

	result.attribute = _attribute_to_string(card.attribute)

	result.race = _race_to_string(card.race)


	#
	# Optional fields
	#

	result.ot = card.get("ot", 0)

	result.alias = card.get("alias", 0)

	result.setcode = card.get("setcode", 0)

	result.category = card.get("category", 0)


	#
	# Defaults
	#

	result.ban_state = 0

	result.ot_state = 0

	result.new_state = 0


	return result



static func _attribute_to_string(value:int) -> String:

	match value:

		1:
			return "EARTH"

		2:
			return "WATER"

		4:
			return "FIRE"

		8:
			return "WIND"

		16:
			return "LIGHT"

		32:
			return "DARK"

		64:
			return "DIVINE"

		_:
			return ""



static func _race_to_string(value:int) -> String:

	match value:

		1:
			return "WARRIOR"

		2:
			return "SPELLCASTER"

		4:
			return "FAIRY"

		8:
			return "FIEND"

		16:
			return "ZOMBIE"

		32:
			return "MACHINE"

		64:
			return "AQUA"

		128:
			return "PYRO"

		256:
			return "ROCK"

		512:
			return "WINGED_BEAST"

		1024:
			return "PLANT"

		2048:
			return "INSECT"

		4096:
			return "THUNDER"

		8192:
			return "DRAGON"

		16384:
			return "BEAST"

		32768:
			return "BEAST_WARRIOR"

		65536:
			return "DINOSAUR"

		131072:
			return "FISH"

		262144:
			return "SEA_SERPENT"

		524288:
			return "REPTILE"

		1048576:
			return "PSYCHIC"

		2097152:
			return "DIVINE_BEAST"

		4194304:
			return "DIVINER_BEAST"

		8388608:
			return "WYRM"

		16777216:
			return "CYBERSE"

		33554432:
			return "ILLUSION"

		_:
			return ""
