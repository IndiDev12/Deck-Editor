extends Panel

@onready var h_flow_container: HFlowContainer = $HBoxContainer/HFlowContainer
@onready var scroll_bar: VScrollBar = $HBoxContainer/VScrollBar

# --- ADDED: Reference to the CardPreview node ---
# Adjust the path "../CardPreview" depending on where CardPreview is in your scene tree.
# If CardPreview is a sibling of this Panel, "../CardPreview" works perfectly.
#@onready var card_preview: Control = get_node_or_null("../CardPreview")
@onready var card_preview: PanelContainer = $"../../../../../CardPreview"
#@export var card_preview: Control


const MAX_ROWS := 7
const MAX_COLUMNS := 12
const MAX_VISIBLE := MAX_ROWS * MAX_COLUMNS
const LOADING_RANGE_SIZE := 100 # 84 visible + 16 buffer ahead

var _update_queued := false
var current_row := 0
var previous_row := 0
var results: Array[Dictionary] = []
var start_index := 0
var columns := MAX_COLUMNS
var rows := MAX_ROWS
var visible_slot_count := MAX_VISIBLE

func _ready() -> void:
	resized.connect(_queue_update)
	h_flow_container.resized.connect(_queue_update)
	scroll_bar.value_changed.connect(_on_scroll_changed)
	
	# --- ADDED: Connect hover signals for all pre-existing deck_cards ---
	#for card in h_flow_container.get_children():
		#if card.has_signal("card_hovered"):
			#card.card_hovered.connect(_on_card_hovered)
# --- BULLETPROOF CONNECTION ---
	if card_preview and card_preview.has_method("update_preview"):
		for card in h_flow_container.get_children():
			if card.has_signal("card_hovered") and not card.card_hovered.is_connected(card_preview.update_preview):
				card.card_hovered.connect(card_preview.update_preview)
				
	_queue_update()

func set_results(card_ids: Array[int]) -> void:
	results.clear()
	for id in card_ids:
		var data := CardDatabase.get_card_data(id)
		if !data.is_empty():
			results.append(data)

	start_index = 0
	scroll_bar.value = 0
	current_row = 0
	previous_row = 0
	_update_scrollbar()
	_refresh_card_data()

func _on_scroll_changed(value: float) -> void:
	var row := int(value)
	if row == current_row: return
	previous_row = current_row
	current_row = row
	start_index = current_row * columns
	_virtual_scroll_rows()

func _update_scrollbar() -> void:
	if columns <= 0: return
	var total_rows := ceili(float(results.size()) / columns)
	scroll_bar.min_value = 0
	scroll_bar.step = 1
	scroll_bar.page = rows
	scroll_bar.max_value = max(rows, total_rows)
	var max_scroll := maxi(0, total_rows - rows)
	scroll_bar.set_value_no_signal(clampf(scroll_bar.value, 0.0, float(max_scroll)))

func _queue_update() -> void:
	if _update_queued: return
	_update_queued = true
	call_deferred("_update_visible_items")

func _update_visible_items() -> void:
	_update_queued = false
	if h_flow_container.get_child_count() == 0: return

	var item: Control = h_flow_container.get_child(0)
	if not results.is_empty(): item.visible = true

	var h_sep := h_flow_container.get_theme_constant("h_separation")
	var v_sep := h_flow_container.get_theme_constant("v_separation")
	var item_w := item.size.x if item.size.x > 0 else item.custom_minimum_size.x
	var item_h := item.size.y if item.size.y > 0 else item.custom_minimum_size.y

	if item_w <= 0 or item_h <= 0:
		call_deferred("_update_visible_items")
		_update_queued = true
		return

	var column_width := item_w + h_sep
	var row_height := item_h + v_sep

	columns = clampi(int(floor((h_flow_container.size.x + h_sep) / column_width)), 1, MAX_COLUMNS)
	rows = clampi(int(floor((size.y + v_sep) / row_height)), 1, MAX_ROWS)
	visible_slot_count = columns * rows

	var total_rows := ceili(float(results.size()) / columns)
	var max_row := maxi(0, total_rows - rows)
	current_row = clampi(start_index / columns, 0, max_row)
	previous_row = current_row
	start_index = current_row * columns

	_update_scrollbar()
	scroll_bar.set_value_no_signal(float(current_row))
	_refresh_card_data()
	_update_grid_visibility()

func _update_grid_visibility() -> void:
	var child_count := h_flow_container.get_child_count()
	for i in child_count:
		var card = h_flow_container.get_child(i)
		card.set_grid_visible(i < visible_slot_count)

# Called on jumps, fast scrolls, and initial load
func _refresh_card_data() -> void:
	for slot in visible_slot_count:
		_assign_slot(slot, start_index + slot)
	_update_loading_range()

func _virtual_scroll_rows() -> void:
	var delta_rows := current_row - previous_row
	match delta_rows:
		0: return
		1: update_bottom_row()
		-1: update_top_row()
		_:
			# Large jump triggers full refresh and queue drop
			_refresh_card_data()

func _assign_slot(slot: int, result_index: int) -> void:
	if slot >= h_flow_container.get_child_count(): return
	var card = h_flow_container.get_child(slot)

	if result_index < 0 or result_index >= results.size():
		card.clear_card()
		return

	var data: Dictionary = results[result_index]
	if !data.has("id"):
		card.clear_card()
		return

	card.setup(data)

# Gathers the 100 IDs in range and tells the loader to drop everything else
func _update_loading_range() -> void:
	var active_ids: Array[int] = []
	var start = start_index
	var end = start_index + LOADING_RANGE_SIZE
	
	for i in range(start, end):
		if i >= 0 and i < results.size():
			var data = results[i]
			if data.has("id"):
				active_ids.append(data["id"])
				
	CardThumbnailLoader.set_active_range(active_ids)

func update_bottom_row() -> void:
	for row in range(0, rows - 1):
		var source_row := row + 1
		for col in columns:
			var dst_slot := row * columns + col
			var src_slot := source_row * columns + col
			if src_slot >= h_flow_container.get_child_count() or dst_slot >= h_flow_container.get_child_count(): continue
			
			var src_card = h_flow_container.get_child(src_slot)
			var dst_card = h_flow_container.get_child(dst_slot)
			if src_card.has_card: dst_card.setup(src_card.card_data)
			else: dst_card.clear_card()

	var bottom_row := rows - 1
	for col in columns:
		var slot := bottom_row * columns + col
		var result_index := start_index + slot
		_assign_slot(slot, result_index)
		
	_update_loading_range()

func update_top_row() -> void:
	for row in range(rows - 1, 0, -1):
		var source_row := row - 1
		for col in columns:
			var dst_slot := row * columns + col
			var src_slot := source_row * columns + col
			if src_slot >= h_flow_container.get_child_count() or dst_slot >= h_flow_container.get_child_count(): continue
			
			var src_card = h_flow_container.get_child(src_slot)
			var dst_card = h_flow_container.get_child(dst_slot)
			if src_card.has_card: dst_card.setup(src_card.card_data)
			else: dst_card.clear_card()

	for col in columns:
		var slot := col
		var result_index := start_index + slot
		_assign_slot(slot, result_index)
		
	_update_loading_range()

func _on_search_box_search_finished(card_ids: Array[int]) -> void:
	set_results(card_ids)
