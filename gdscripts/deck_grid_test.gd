@tool
class_name SpreadFlowContainer
extends HFlowContainer

@export var item_size: Vector2 = Vector2(48, 70):
	set(value):
		item_size = value
		queue_sort()

## Normal minimum spacing between items
@export var min_h_separation: int = 4:
	set(value):
		min_h_separation = value
		queue_sort()


func _notification(what: int) -> void:
	if what == NOTIFICATION_PRE_SORT_CHILDREN:
		_on_pre_sort()


func _on_pre_sort() -> void:
	if size.x <= 0 or size.y <= 0:
		return

	var visible_children := 0
	for child in get_children():
		if child is Control and child.visible:
			visible_children += 1

	if visible_children <= 1:
		_apply_h_separation(0)
		return

	var w_c: float = size.x
	var h_c: float = size.y
	var w_i: float = item_size.x
	var h_i: float = item_size.y

	var v_sep: int = get_theme_constant("v_separation", "HFlowContainer")
	var row_height: float = h_i + v_sep

	# Maximum rows that can fit vertically
	var max_rows := maxi(1, floori((h_c + v_sep) / row_height))

	# Find the smallest number of rows that avoids overlap
	var rows := 1

	while true:
		var cols := ceili(float(visible_children) / rows)

		var required_width := cols * w_i + (cols - 1) * min_h_separation

		if required_width <= w_c:
			break

		if rows >= max_rows:
			break

		rows += 1

	var cols := ceili(float(visible_children) / rows)

	var total_item_width := cols * w_i
	var remaining_space := w_c - total_item_width

	var h_sep: int

	if rows < max_rows:
		# Height is not yet exhausted:
		# spacing should never go below min_h_separation.
		if cols > 1:
			h_sep = maxi(
				min_h_separation,
				floori(remaining_space / float(cols - 1))
			)
		else:
			h_sep = 0

	else:
		# We've already used all rows.
		# Now overlap if necessary.
		if cols > 1:
			h_sep = floori(remaining_space / float(cols - 1))
		else:
			h_sep = 0

	_apply_h_separation(h_sep)


func _apply_h_separation(new_sep: int) -> void:
	if (
		!has_theme_constant_override("h_separation")
		or get_theme_constant("h_separation", "HFlowContainer") != new_sep
	):
		add_theme_constant_override("h_separation", new_sep)
