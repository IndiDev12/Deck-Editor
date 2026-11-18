# CardInfoUpdater.gd

class_name CardInfoUpdater
extends RefCounted


static func update(card, data:Dictionary) -> void:

	#
	# Name
	#
	card.card_name.text = data.name


	#
	# ATK
	#
	if data.has("atk"):

		if data.atk < 0:
			card.atk.text = "?"
		else:
			card.atk.text = str(data.atk)

	else:
		card.atk.text = ""


	#
	# DEF
	#
	if data.has("def"):

		if data.def < 0:
			card.def_.text = "?"
		else:
			card.def_.text = str(data.def)

	else:
		card.def_.text = ""


	#
	# Level / Rank / Link Rating
	#
	if data.has("level"):

		var level:int = data.level

		#
		# Pendulum monsters store scales in upper bits
		#
		card.level_rank.text = str(level & 0xff)

	else:

		card.level_rank.text = ""


	#
	# Link Count
	#
	if data.has("level"):

		card.link_count.text = str(data.level)

	else:

		card.link_count.text = ""


	#
	# Pendulum Scale
	#
	if data.has("level"):

		var scale:int = (data.level >> 24) & 0xff

		card.pendulum_scale.text = str(scale)

	else:

		card.pendulum_scale.text = ""
