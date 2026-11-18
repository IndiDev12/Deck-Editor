extends HBoxContainer

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

enum ViewMode {
	THUMBNAIL,
	LIST
}


var card_data: Dictionary


#
# Thumbnail
#

@onready var card_thumbnail: TextureRect = $CardThumbnail


#
# Tags
#

@onready var ban_tag: PanelContainer = $CardThumbnail/Tags/BanTag
@onready var ban_label: Label = $CardThumbnail/Tags/BanTag/Label

@onready var ot_tag: PanelContainer = $CardThumbnail/Tags/OtTag
@onready var ot_label: Label = $CardThumbnail/Tags/OtTag/Label

@onready var new_tag: Label = $CardThumbnail/Tags/NewTag


#
# Card info panel
#

@onready var card_info: PanelContainer = $CardInfo


#
# Labels
#

@onready var card_name: Label = (
	$CardInfo/VBoxContainer/CardName
)

@onready var def_: Label = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/DefPreview/HBoxContainer/Def
)

@onready var atk: Label = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/DefPreview2/HBoxContainer/Atk
)

@onready var pendulum_scale: Label = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/PendulumScalePreview2/HBoxContainer/PendulumScale
)

@onready var level_rank: Label = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LevelRankPreview/HBoxContainer/LevlRank
)

@onready var link_count: Label = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview/GridContainer/Count
)


#
# TextureRects
#

@onready var race: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/CardTypesPreview/HBoxContainer/Race
)

@onready var attribute: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/CardTypesPreview/HBoxContainer/Attribute
)

@onready var level_rank_icon: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LevelRankPreview/HBoxContainer/TextureRect2
)

@onready var pendulum_icon: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/PendulumScalePreview2/HBoxContainer/TextureRect2
)


#
# Preview containers
#

@onready var pendulum_scale_preview: PanelContainer = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/PendulumScalePreview2
)

@onready var level_rank_preview: PanelContainer = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LevelRankPreview
)

@onready var links_preview: PanelContainer = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview
)


#
# Link arrows
#

@onready var tl: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview/GridContainer/tl
)

@onready var t: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview/GridContainer/t
)

@onready var tr: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview/GridContainer/tr
)

@onready var l: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview/GridContainer/l
)

@onready var r: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview/GridContainer/r
)

@onready var bl: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview/GridContainer/bl
)

@onready var b: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview/GridContainer/b
)

@onready var br: TextureRect = (
	$CardInfo/VBoxContainer/PanelContainer/HBoxContainer2/LinksPreview/GridContainer/br
)


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


@export var view_mode: ViewMode = ViewMode.THUMBNAIL:
	set(value):
		view_mode = value

		if is_node_ready():
			_update_view_mode()


var card_id:int

func _ready() -> void:

	CardThumbnailLoader.thumbnail_loaded.connect(
			_on_thumbnail_loaded
		)

	_update_ban_tag()

	_update_ot_tag()

	_update_new_tag()

	_update_view_mode()


#func _process(_delta):
#
	#if card_thumbnail.texture == CardThumbnailLoader.DEFAULT_TEXTURE:
#
		#var tex := CardThumbnailLoader.get_texture(card_id)
#
		#if tex != ThumbnailLoader.DEFAULT_TEXTURE:
#
			#card_thumbnail.texture = tex
#
			#set_process(false)
#
#
func setup(data: Dictionary) -> void:

	card_data = data
	card_id = data.id

	CardInfoUpdater.update(self, data)

	CardVisibilityUpdater.update(self, data)

	CardTextureUpdater.update(self, data)

	CardLinkUpdater.update(self, data)
	#set_process(true)


func _update_view_mode() -> void:

	var list_mode := view_mode == ViewMode.LIST

	card_info.visible = list_mode

	if list_mode:

		custom_minimum_size = Vector2(210, 70)

		size_flags_horizontal = Control.SIZE_EXPAND_FILL

	else:

		custom_minimum_size = Vector2(48, 70)

		size_flags_horizontal = Control.SIZE_SHRINK_BEGIN



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


func _on_thumbnail_loaded(id:int, texture:Texture2D):

	if id != card_id:
		return

	card_thumbnail.texture = texture
