# CardVisibilityUpdater.gd

class_name CardVisibilityUpdater
extends RefCounted


static func update(card, data:Dictionary) -> void:

	var type:int = data.type


	#
	# View mode
	#
	var list_mode :bool= card.view_mode == card.ViewMode.LIST

	card.card_info.visible = list_mode

	if list_mode:
		card.custom_minimum_size = Vector2(210, 70)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	else:
		card.custom_minimum_size = Vector2(48, 70)
		card.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN


	#
	# Pendulum scale
	#
	card.pendulum_scale_preview.visible = CardTypeHelper.is_pendulum(type)


	#
	# Level / Rank
	#
	card.level_rank_preview.visible = (
		CardTypeHelper.is_monster(type)
		and not CardTypeHelper.is_link(type)
	)


	#
	# Link arrows
	#
	card.links_preview.visible = CardTypeHelper.is_link(type)


	#
	# Attribute
	#
	card.attribute.visible = true


	#
	# Race
	#
	card.race.visible = CardTypeHelper.is_monster(type)


	#
	# Ban tag
	#
	card.ban_tag.visible = card.ban_state != card.BanState.NONE


	#
	# OT tag
	#
	card.ot_tag.visible = (
		card.ot_state != card.OTState.HIDDEN
		and card.ot_state != card.OTState.BOTH
	)


	#
	# New tag
	#
	card.new_tag.visible = (
		card.new_state == card.NewState.NEW
	)
