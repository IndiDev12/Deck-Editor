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


#
# CARD DATA
#

var card_data: Dictionary = {}
var card_id := 0

# cached fields for easy access
var card_type := 0
var attribute := 0
var race := 0

var attack := 0
var defense := 0
var level := 0


#
# VISIBILITY STATES
#

var has_card := false
var in_grid_visible := true


#
# TAGS
#

@onready var ban_tag: PanelContainer = $Tags/BanTag
@onready var ban_label: Label = $Tags/BanTag/Label

@onready var ot_tag: PanelContainer = $Tags/OtTag
@onready var ot_label: Label = $Tags/OtTag/Label

@onready var new_tag: Label = $Tags/NewTag


#
# EXPORTED STATES
#

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


#
# READY
#

func _ready() -> void:

	if !CardThumbnailLoader.thumbnail_loaded.is_connected(
		_on_thumbnail_loaded
	):
		CardThumbnailLoader.thumbnail_loaded.connect(
			_on_thumbnail_loaded
		)

	_update_ban_tag()
	_update_ot_tag()
	_update_new_tag()
	_update_visibility()


func _exit_tree() -> void:

	if CardThumbnailLoader.thumbnail_loaded.is_connected(
		_on_thumbnail_loaded
	):
		CardThumbnailLoader.thumbnail_loaded.disconnect(
			_on_thumbnail_loaded
		)


#
# CARD SETUP
#

func setup(data: Dictionary) -> void:

	if !data.has("id"):
		clear_card()
		return

	has_card = true

	#card_data = data
	card_data = data.duplicate(true) 

	card_id = data["id"]

	card_type = data.get("type", 0)
	attribute = data.get("attribute", 0)
	race = data.get("race", 0)

	attack = data.get("attack", 0)
	defense = data.get("defense", 0)
	level = data.get("level", 0)

	texture = CardThumbnailLoader.get_texture(card_id)

	_update_visibility()


func clear_card() -> void:

	has_card = false

	#card_data.clear()
	card_data = {} 

	card_id = 0

	card_type = 0
	attribute = 0
	race = 0

	attack = 0
	defense = 0
	level = 0

	texture = CardThumbnailLoader.DEFAULT_TEXTURE

	_update_visibility()


#
# GRID VISIBILITY
#

func set_grid_visible(value: bool) -> void:

	if in_grid_visible == value:
		return

	in_grid_visible = value

	_update_visibility()


func _update_visibility() -> void:

	visible = (
		has_card
		and
		in_grid_visible
	)


#
# NEW TAG
#

func _update_new_tag() -> void:

	new_tag.visible = (
		new_state == NewState.NEW
	)


#
# BAN TAG
#

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


#
# OT TAG
#

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


#
# THUMBNAIL CALLBACK
#

func _on_thumbnail_loaded(
	id: int,
	texture_: Texture2D
) -> void:

	if !has_card:
		return

	if id != card_id:
		return

	texture = texture_
