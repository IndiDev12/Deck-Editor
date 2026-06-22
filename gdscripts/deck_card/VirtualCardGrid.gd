extends Control

const CARD_SCENE := preload(
	"res://scenes/reusable_components/deck_card.tscn"
)

const POOL_SIZE := 100

const CARD_WIDTH := 48
const CARD_HEIGHT := 70

const H_SPACING := 2
const V_SPACING := 2


var result_ids:Array[int] = []

var card_pool:Array = []

var first_visible_index := -1

var cards_per_row := 1

@onready var scroll_container : ScrollContainer = get_parent()


func _ready():

	resized.connect(_update_layout)

	_create_pool()

	_update_layout()

	set_process(true)


func set_results(ids:Array[int]):

	result_ids = ids

	_update_layout()

	first_visible_index = -1

	_refresh_visible_cards()


func _create_pool():

	for i in POOL_SIZE:

		var card = CARD_SCENE.instantiate()

		card.position = Vector2.ZERO

		add_child(card)

		card_pool.append(card)


func _update_layout():

	var available_width = max(size.x, 1)

	cards_per_row = max(
		1,
		int(
			available_width /
			(CARD_WIDTH + H_SPACING)
		)
	)

	var rows = ceili(
		float(result_ids.size()) /
		float(cards_per_row)
	)

	custom_minimum_size.y = (
		rows *
		(CARD_HEIGHT + V_SPACING)
	)


func _process(_delta):

	_refresh_visible_cards()


func _refresh_visible_cards():

	if result_ids.is_empty():
		return

	var scroll_y = scroll_container.scroll_vertical

	var first_row = int(
		scroll_y /
		(CARD_HEIGHT + V_SPACING)
	)

	var new_first_index = (
		first_row *
		cards_per_row
	)

	if new_first_index == first_visible_index:
		return

	first_visible_index = new_first_index

	for i in card_pool.size():

		var card_index = (
			first_visible_index + i
		)

		var card = card_pool[i]

		if card_index >= result_ids.size():

			card.hide()

			continue

		card.show()

		var row = card_index / cards_per_row

		var column = card_index % cards_per_row

		card.position = Vector2(
			column * (CARD_WIDTH + H_SPACING),
			row * (CARD_HEIGHT + V_SPACING)
		)

		var id = result_ids[card_index]

		card.setup(
			CardDataCache.get_data(id)
		)
