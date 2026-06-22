extends Panel

@onready var h_flow_container: HFlowContainer = $HBoxContainer/HFlowContainer

const MAX_ROWS := 7
const MAX_COLUMNS := 12

var _update_queued := false


func _ready() -> void:
	resized.connect(_queue_update)
	_queue_update()


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
