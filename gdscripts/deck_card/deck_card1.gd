extends TextureRect

enum BanState {
	NONE,
	FORBIDDEN,
	LIMITED,
	SEMI_LIMITED,
	UNLIMITED
}

enum OTState {
	HIDDEN,
	OCG,
	TCG,
	BOTH,
	ANIMEMANGA,
	RUSH
}

enum NewState {
	NORMAL,
	NEW
}

var card_data: Dictionary
var card_id: int


#
# Tags
#

@onready var ban_tag: PanelContainer = $Tags/BanTag
@onready var ban_label: Label = $Tags/BanTag/Label

@onready var ot_tag: PanelContainer = $Tags/OtTag
@onready var ot_label: Label = $Tags/OtTag/Label

@onready var new_tag: Label = $Tags/NewTag


@export var ban_state: BanState = BanState.NONE:
	set(value):
		ban_state = value
		if is_node_ready():
			_update_ban_tag()


@export var ot_state: OTState = OTState.HIDDEN:
	set(value):
		ot_state = value
		if is_node_ready():
			_update_ot_tag()


@export var new_state: NewState = NewState.NORMAL:
	set(value):
		new_state = value
		if is_node_ready():
			_update_new_tag()


func _ready() -> void:
	CardThumbnailLoader.thumbnail_loaded.connect(
		_on_thumbnail_loaded
	)

	_update_ban_tag()
	_update_ot_tag()
	_update_new_tag()


func setup(data: Dictionary) -> void:
	card_data = data
	card_id = data.id


func _update_new_tag() -> void:
	new_tag.visible = (
		new_state == NewState.NEW
	)


func _update_ban_tag() -> void:
	match ban_state:
		BanState.NONE:
			ban_tag.visible = false

		BanState.FORBIDDEN:
			ban_tag.visible = true
			ban_label.text = "0"
			ban_label.modulate = Color.WHITE
			ban_tag.self_modulate = Color.RED

		BanState.LIMITED:
			ban_tag.visible = true
			ban_label.text = "1"
			ban_label.modulate = Color.BLACK
			ban_tag.self_modulate = Color.ORANGE_RED

		BanState.SEMI_LIMITED:
			ban_tag.visible = true
			ban_label.text = "2"
			ban_label.modulate = Color.BLACK
			ban_tag.self_modulate = Color.YELLOW

		BanState.UNLIMITED:
			ban_tag.visible = false


func _update_ot_tag() -> void:
	match ot_state:
		OTState.HIDDEN:
			ot_tag.visible = false

		OTState.OCG:
			ot_tag.visible = true
			ot_label.text = "O"
			ot_label.modulate = Color.WHITE
			ot_tag.self_modulate = Color.GREEN

		OTState.TCG:
			ot_tag.visible = true
			ot_label.text = "T"
			ot_label.modulate = Color.WHITE
			ot_tag.self_modulate = Color.BLUE

		OTState.BOTH:
			ot_tag.visible = false

		OTState.ANIMEMANGA:
			ot_tag.visible = true
			ot_label.text = "A"
			ot_label.modulate = Color.WHITE
			ot_tag.self_modulate = Color.HOT_PINK

		OTState.RUSH:
			ot_tag.visible = true
			ot_label.text = "R"
			ot_label.modulate = Color.WHITE
			ot_tag.self_modulate = Color.ORANGE


func _on_thumbnail_loaded(id: int, texture_: Texture2D) -> void:
	if id != card_id:
		return

	texture = texture_
