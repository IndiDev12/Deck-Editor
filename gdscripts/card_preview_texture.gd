extends TextureRect

const CARD_RATIO := 24.0 / 35.0 # width / height

var flip_tween: Tween
var next_texture: Texture2D = null

func _ready() -> void:
	resized.connect(_update_pivot)
	_update_pivot()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		var target_height := size.x / CARD_RATIO
		if custom_minimum_size.y != target_height:
			custom_minimum_size.y = target_height

func _update_pivot() -> void:
	pivot_offset = size * 0.5

func play_flip_animation(new_tex: Texture2D) -> void:
	# If hovering extremely fast, we interrupt the previous flip.
	# We snap the old pending texture instantly, then apply the new one.
	if flip_tween and flip_tween.is_valid():
		flip_tween.kill()
		if next_texture:
			texture = next_texture
		scale = Vector2.ONE
		texture = new_tex
		next_texture = null
		return

	# Normal animation start
	next_texture = new_tex
	_update_pivot()
	scale = Vector2.ONE

	flip_tween = create_tween()
	flip_tween.set_trans(Tween.TRANS_QUAD)
	flip_tween.set_ease(Tween.EASE_IN_OUT)

	# Reduced time slightly to make it feel more responsive (0.1s)
	flip_tween.tween_property(self, "scale:x", 0.0, 0.1)
	flip_tween.tween_callback(_update_preview_card)
	flip_tween.tween_property(self, "scale:x", 1.0, 0.1)

func _update_preview_card() -> void:
	if next_texture:
		texture = next_texture
		next_texture = null
