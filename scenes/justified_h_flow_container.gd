@tool
class_name StretchFlowContainer
extends Container

@export_range(1, 100, 1)
var max_rows := 8:
	set(value):
		max_rows = max(1, value)
		queue_sort()

@export var v_separation := 8:
	set(value):
		v_separation = value
		queue_sort()


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_layout_children()


func _get_visible_controls() -> Array[Control]:
	var result: Array[Control] = []

	for child in get_children():
		if child is Control and child.visible:
			result.append(child)

	return result


func _layout_children() -> void:
	var controls := _get_visible_controls()

	if controls.is_empty():
		return

	var rows: Array = []

	for i in max_rows:
		rows.append([])

	# --------------------------------------------------
	# Distribute cards among rows
	# --------------------------------------------------

	var row_index := 0

	for control in controls:
		rows[row_index].append(control)

		if row_index < max_rows - 1:
			row_index += 1
		else:
			row_index = 0

	# Remove empty rows
	rows = rows.filter(func(r): return not r.is_empty())

	var y := 0.0

	for row_idx in rows.size():
		var row: Array = rows[row_idx]

		var row_height := 0.0
		var total_width := 0.0

		for child: Control in row:
			var size := child.get_combined_minimum_size()

			total_width += size.x
			row_height = max(row_height, size.y)

		var count := row.size()

		var last_row := row_idx == rows.size() - 1

		var stretch_row := not last_row

		if last_row:
			# Stretch only if every row is occupied
			stretch_row = rows.size() == max_rows

		var x := 0.0

		if count == 1:
			var child: Control = row[0]
			var child_size := child.get_combined_minimum_size()

			fit_child_in_rect(
				child,
				Rect2(
					Vector2(0, y),
					child_size
				)
			)

			y += row_height + v_separation
			continue

		var available_width := size.x

		if stretch_row:
			# --------------------------------------------------
			# Stretch or overlap
			# --------------------------------------------------

			var gap := (available_width - total_width) / float(count - 1)

			for child: Control in row:
				var child_size := child.get_combined_minimum_size()

				fit_child_in_rect(
					child,
					Rect2(
						Vector2(x, y),
						child_size
					)
				)

				x += child_size.x + gap
		else:
			# --------------------------------------------------
			# Left-aligned final row
			# --------------------------------------------------

			for child: Control in row:
				var child_size := child.get_combined_minimum_size()

				fit_child_in_rect(
					child,
					Rect2(
						Vector2(x, y),
						child_size
					)
				)

				x += child_size.x

		y += row_height + v_separation


func _get_minimum_size() -> Vector2:
	var controls := _get_visible_controls()

	if controls.is_empty():
		return Vector2.ZERO

	var max_width := 0.0
	var total_height := 0.0

	var row_height := 0.0
	var row_count := 0

	for child in controls:
		var s := child.get_combined_minimum_size()

		max_width = max(max_width, s.x)
		row_height = max(row_height, s.y)

	if controls.size() > 0:
		row_count = min(max_rows, controls.size())

	total_height = row_count * row_height + max(0, row_count - 1) * v_separation

	return Vector2(max_width, total_height)
