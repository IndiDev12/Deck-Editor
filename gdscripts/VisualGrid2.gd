extends Panel

@onready var h_flow_container: HFlowContainer = $HBoxContainer/HFlowContainer
@onready var scroll_bar: VScrollBar = $HBoxContainer/VScrollBar

const MAX_ROWS := 7
const MAX_COLUMNS := 12
const MAX_VISIBLE := MAX_ROWS * MAX_COLUMNS

var _update_queued := false

# Entire search result
var result_ids: Array[int] = []

# Which card in result_ids corresponds to slot 0
var start_index := 0

# Remember what each slot currently displays
var displayed_ids: Array[int] = []


func _ready() -> void:
	print_tree_pretty()
	resized.connect(_queue_update)
	scroll_bar.value_changed.connect(_on_scroll_changed)

	displayed_ids.resize(MAX_VISIBLE)

	for i in displayed_ids.size():
		displayed_ids[i] = -1

	_queue_update()


func set_results(ids: Array[int]) -> void:
	result_ids = ids

	print("result ids are: ", result_ids)

	start_index = 0
	scroll_bar.value = 0
	scroll_bar.max_value = max(0, result_ids.size() - MAX_VISIBLE)

	_refresh_cards()


func _on_scroll_changed(value: float) -> void:
	start_index = int(value)
	_refresh_cards()


func _refresh_cards() -> void:

	var child_count := h_flow_container.get_child_count()

	for slot in child_count:

		var index := start_index + slot
		var card = h_flow_container.get_child(slot)

		if index >= result_ids.size():
			card.visible = false
			displayed_ids[slot] = -1
			continue

		card.visible = true

		var card_id := result_ids[index]

		if displayed_ids[slot] == card_id:
			continue

		displayed_ids[slot] = card_id

		var data = CardDatabase.get_card_data(card_id)
		card.setup(data)


func _queue_update() -> void:

	if _update_queued:
		return

	_update_queued = true
	call_deferred("_update_visible_items")


func _update_visible_items() -> void:

	_update_queued = false

	if h_flow_container.get_child_count() == 0:
		return

	var item: Control = h_flow_container.get_child(0)

	var h_sep := h_flow_container.get_theme_constant("h_separation")
	var v_sep := h_flow_container.get_theme_constant("v_separation")

	var column_width := item.size.x + h_sep
	var row_height := item.size.y + v_sep

	var columns := clampi(
		int(floor((h_flow_container.size.x + h_sep) / column_width)),
		1,
		MAX_COLUMNS
	)

	var rows := clampi(
		int(floor((size.y + v_sep) / row_height)),
		1,
		MAX_ROWS
	)

	var visible_count := columns * rows

	for i in h_flow_container.get_child_count():
		h_flow_container.get_child(i).visible = i < visible_count


func _on_search_box_search_finished(card_ids: Array[int]) -> void:
	set_results(card_ids)
