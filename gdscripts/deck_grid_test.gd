@tool
class_name SpreadFlowContainer
extends HFlowContainer

@export var item_size: Vector2 = Vector2(48, 70):
	set(value):
		item_size = value
		queue_sort()

## Normal minimum spacing between items (never expands beyond this)
@export var min_h_separation: int = 4:
	set(value):
		min_h_separation = value
		queue_sort()

# --- Visibility Mechanism ---
var visible_slot_count := 0

func _ready() -> void:
	# Initialize to make all existing children active by default
	if visible_slot_count == 0:
		visible_slot_count = get_child_count()
	_update_grid_visibility()

func _notification(what: int) -> void:
	# Run our math just before Godot's native layout runs
	if what == NOTIFICATION_PRE_SORT_CHILDREN:
		_on_pre_sort()

func set_visible_slot_count(count: int) -> void:
	visible_slot_count = count
	_update_grid_visibility()
	queue_sort()

func _update_grid_visibility() -> void:
	var child_count := get_child_count()
	for i in child_count:
		var card = get_child(i)
		if card.has_method("set_grid_visible"):
			card.set_grid_visible(i < visible_slot_count)
		elif card is Control:
			# Fallback if it doesn't have the method
			card.visible = (i < visible_slot_count)

# --- Layout Logic ---
func _on_pre_sort() -> void:
	if size.x <= 0 or size.y <= 0:
		return

	var visible_count := 0
	for child in get_children():
		if child is Control and child.visible:
			visible_count += 1

	if visible_count == 0:
		_apply_h_separation(min_h_separation)
		return

	var w_c: float = size.x
	var h_c: float = size.y
	var w_i: float = item_size.x
	var h_i: float = item_size.y

	var v_sep: int = get_theme_constant("v_separation", "HFlowContainer")
	var row_height: float = h_i + v_sep

	# 1. Calculate maximum rows that can fit vertically
	var max_rows := maxi(1, floori((h_c + v_sep) / row_height))

	# 2. Calculate how many columns fit naturally with min_h_separation
	var cols_with_min_sep := 1
	if w_i > 0:
		cols_with_min_sep = floori((w_c + min_h_separation) / (w_i + min_h_separation))
		cols_with_min_sep = maxi(1, cols_with_min_sep)

	# 3. Check if using min_h_separation would create too many rows
	var rows_needed := ceili(float(visible_count) / float(cols_with_min_sep))

	var final_h_sep: int = min_h_separation

	# 4. If we need more rows than allowed, force overlap
	if rows_needed > max_rows:
		# Calculate exact columns needed to force everything into max_rows
		var forced_cols := ceili(float(visible_count) / float(max_rows))
		
		if forced_cols > 1:
			# Calculate the negative separation required to fit forced_cols into width
			var total_item_width := forced_cols * w_i
			var remaining_space := w_c - total_item_width
			final_h_sep = floori(remaining_space / float(forced_cols - 1))
		else:
			# Extreme case: forced to 1 column but still over max_rows (shouldn't happen normally)
			final_h_sep = min_h_separation

	# Apply the calculated separation. Godot's native HFlowContainer will now 
	# handle the actual positioning, respecting native Alignment and Last Wrap Alignment!
	_apply_h_separation(final_h_sep)


func _apply_h_separation(new_sep: int) -> void:
	if (
		!has_theme_constant_override("h_separation")
		or get_theme_constant("h_separation", "HFlowContainer") != new_sep
	):
		add_theme_constant_override("h_separation", new_sep)
