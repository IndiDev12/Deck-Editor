# CardTextureUpdater.gd

class_name CardTextureUpdater
extends RefCounted


static func update(card, data:Dictionary) -> void:

	_update_thumbnail(card, data)

	_update_attribute(card, data)

	_update_race(card, data)

	_update_level_rank_icon(card, data)

	_update_pendulum_icon(card)



static func _update_thumbnail(card, data:Dictionary) -> void:

	card.card_thumbnail.texture = CardThumbnailLoader.get_texture(data.id)



static func _update_attribute(card, data:Dictionary) -> void:

	if CardTypeHelper.is_spell(data.type):

		card.attribute.texture = (
			CardTextureMaps.ATTRIBUTE_TEXTURES["SPELL"]
		)

		return


	if CardTypeHelper.is_trap(data.type):

		card.attribute.texture = (
			CardTextureMaps.ATTRIBUTE_TEXTURES["TRAP"]
		)

		return


	if data.attribute in CardTextureMaps.ATTRIBUTE_TEXTURES:

		card.attribute.texture = (
			CardTextureMaps.ATTRIBUTE_TEXTURES[data.attribute]
		)



static func _update_race(card, data:Dictionary) -> void:

	if data.race in CardTextureMaps.RACE_TEXTURES:

		card.race.texture = (
			CardTextureMaps.RACE_TEXTURES[data.race]
		)



static func _update_level_rank_icon(card, data:Dictionary) -> void:

	if CardTypeHelper.is_xyz(data.type):

		card.level_rank_icon.texture = (
			CardTextureMaps.RANK_TEXTURE
		)

	else:

		card.level_rank_icon.texture = (
			CardTextureMaps.LEVEL_TEXTURE
		)



static func _update_pendulum_icon(card) -> void:

	card.pendulum_icon.texture = (
		CardTextureMaps.PENDULUM_TEXTURE
	)
