@tool
extends HFlowContainer
class_name BoundedHFlowContainer

## The default horizontal spacing when items fit naturally.
@export var base_h_separation: int = 4:
	set(v):
		base_h_separation = v
		queue_sort() # Re-trigger layout when changed in inspector

## The default vertical spacing between rows.
@export var base_v_separation: int = 4:
	set(v):
		base_v_separation = v
		queue_sort()

func _notification(what: int) -> void:
	# Intercept the layout notification before the native HFlowContainer sorts
	if what == NOTIFICATION_SORT_CHILDREN:
		_adjust_h_separation()

func _adjust_h_separation() -> void:
	var parent_ctrl := get_parent() as Control
	if not parent_ctrl:
		return

	var available_height: float = parent_ctrl.size.y
	var available_width: float = size.x

	var first_child: Control = null
	var visible_items := 0

	# Find the first visible child to get item dimensions and count visible items
	for child in get_children():
		if child is Control and child.visible:
			if not first_child:
				first_child = child
			visible_items += 1

	if not first_child or visible_items == 0:
		return

	# The prompt states items are all the same size
	var item_size := first_child.get_combined_minimum_size()
	if item_size.x <= 0 or item_size.y <= 0:
		return

	var item_w: float = item_size.x
	var item_h: float = item_size.y

	# 1. Calculate maximum rows that fit within the parent's height
	var max_rows := maxi(1, floori((available_height + base_v_separation) / (item_h + base_v_separation)))

	# 2. Calculate how many items fit per row natively (using base spacing)
	var natural_items_per_row := maxi(1, floori((available_width + base_h_separation) / (item_w + base_h_separation)))
	var natural_rows_needed := ceili(float(visible_items) / float(natural_items_per_row))

	# 3. If it fits vertically with base spacing, apply base spacing natively
	if natural_rows_needed <= max_rows:
		add_theme_constant_override("h_separation", base_h_separation)
		add_theme_constant_override("v_separation", base_v_separation)
		return

	# 4. If it doesn't fit, calculate how many items MUST be on a single row to fit vertically
	var items_per_row := ceili(float(visible_items) / float(max_rows))

	if items_per_row <= 1:
		add_theme_constant_override("h_separation", base_h_separation)
		return

	# 5. Calculate the required h_separation to fit them all horizontally
	# Equation: available_width = (items_per_row * item_w) + ((items_per_row - 1) * h_sep)
	var required_h_sep := (available_width - (float(items_per_row) * item_w)) / float(items_per_row - 1)
	
	# Subtract a tiny amount (0.5px) to prevent floating-point precision 
	# issues from causing the last item to wrap to the next line anyway.
	required_h_sep -= 0.5

	# 6. Apply the calculated overlap, ensuring it doesn't exceed base separation
	if required_h_sep < base_h_separation:
		add_theme_constant_override("h_separation", floori(required_h_sep))
	else:
		add_theme_constant_override("h_separation", base_h_separation)
