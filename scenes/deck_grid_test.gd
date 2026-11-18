## DynamicHFlowContainer
##
## Wrapping row layout where horizontal gaps auto-expand / auto-compress
## so every row reaches exactly the right and left edges of the container —
## no dead margin, no fixed h_separation.
##
## Drop this script on a plain Container node, then add your uniform-size
## children.  Resize the container freely; rows reflow and gaps adjust in
## real time both in-editor and at runtime.
##
## Extending Container directly is intentional: if we extended HFlowContainer
## its own NOTIFICATION_SORT_CHILDREN handler would fight ours for the same
## children.
##
## Godot 4.x  —  @tool so the layout is live in the editor.
@tool
class_name DynamicHFlowContainer
extends Container


# ── Exported settings ────────────────────────────────────────────────────────

## Width × height assumed for every child.
## All children are force-fitted to this size by the layout.
@export var item_size := Vector2i(48, 70):
	set(v):
		item_size = v
		queue_sort()

## Vertical gap between rows (pixels).
@export var v_separation: int = 8:
	set(v):
		v_separation = v
		queue_sort()

## When true  → every row (including the last, partial one) is stretched
##              full-width.  Can look very gappy if the last row has few items.
## When false → the last row is left-aligned at zero gap (natural / safe).
@export var spread_last_row := false:
	set(v):
		spread_last_row = v
		queue_sort()


# ── Godot Container overrides ─────────────────────────────────────────────────

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_layout()


## Minimum size: at least one item tall and wide.
func _get_minimum_size() -> Vector2:
	return Vector2(item_size.x, item_size.y)


# ── Internal helpers ──────────────────────────────────────────────────────────

## Returns visible, in-tree-order Control children (skips non-Controls and
## hidden nodes so they don't occupy row slots).
func _visible_children() -> Array[Control]:
	var out: Array[Control] = []
	for child in get_children():
		if child is Control and (child as Control).visible:
			out.append(child as Control)
	return out


## Core layout routine — called every time Godot requests a sort (resize,
## child added/removed, queue_sort(), theme change via setter, etc.).
func _layout() -> void:
	var cw := size.x              # container width  (may change every frame)
	var iw := float(item_size.x)  # item width
	var ih := float(item_size.y)  # item height

	if iw <= 0.0 or ih <= 0.0:
		return

	var children := _visible_children()
	if children.is_empty():
		return

	# ── How many items per row? ───────────────────────────────────────────────
	# Start from the zero-gap count: floor(cw / iw).
	# This guarantees h_gap ≥ 0 on full rows (items never overlap).
	# A single item is always the minimum so the loop doesn't stall.
	var cols := maxi(1, int(cw / iw))

	# ── Split children into rows ──────────────────────────────────────────────
	var rows: Array[Array] = []   # Array of Array[Control]
	var idx := 0
	while idx < children.size():
		rows.append(children.slice(idx, idx + cols) as Array)
		idx += cols

	# ── Position every item ───────────────────────────────────────────────────
	var y      := 0.0
	var last_r := rows.size() - 1

	for r in rows.size():
		var row := rows[r] as Array
		var n          := row.size()
		var is_last    := (r == last_r)

		# Dynamic gap for this row.
		#   Full rows always spread.
		#   Last (partial) row spreads only when spread_last_row is set.
		var h_gap := 0.0
		if n > 1 and (not is_last or spread_last_row):
			# Distribute the leftover width evenly across the (n-1) gaps.
			h_gap = (cw - float(n) * iw) / float(n - 1)

		var x := 0.0
		for child: Control in row:
			# round() snaps to nearest pixel; avoids sub-pixel blurriness.
			fit_child_in_rect(child, Rect2(round(x), round(y), iw, ih))
			x += iw + h_gap

		y += ih + float(v_separation)

	# ── Tell parent how tall we are ───────────────────────────────────────────
	# Subtract the trailing v_separation that was added after the last row.
	var needed_h := y - float(v_separation)
	if custom_minimum_size.y != needed_h:
		# Conditional write prevents triggering an unnecessary extra sort pass.
		custom_minimum_size.y = needed_h
