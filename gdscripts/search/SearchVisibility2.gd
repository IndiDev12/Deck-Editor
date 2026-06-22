class_name SearchVisibility2
extends RefCounted


#
# =====================================================
# MAIN CARD TYPE PANELS
# =====================================================
#

static func update_main_type(
	main_type:int,
	monster_search:Control,
	spell_search:Control,
	trap_search:Control
) -> void:

	monster_search.visible = (
		main_type == SearchMaps.MainCardType.MONSTER
	)

	spell_search.visible = (
		main_type == SearchMaps.MainCardType.SPELL
	)

	trap_search.visible = (
		main_type == SearchMaps.MainCardType.TRAP
	)


#
# =====================================================
# RANGE VISIBILITY
# =====================================================
#

static func update_range_visibility(
	container:Node
) -> void:

	if container == null:
		return

	var option_button := container.find_child(
		"OptionButton",
		true,
		false
	) as OptionButton

	var line1 := container.find_child(
		"LineEdit",
		true,
		false
	) as LineEdit

	var line2 := container.find_child(
		"LineEdit2",
		true,
		false
	) as LineEdit

	if option_button == null or line1 == null:
		return

	var selected_mode = option_button.selected

	# Hide all inputs if "Any" or "?" is selected
	if selected_mode == SearchMaps.CompareMode.ANY or selected_mode == SearchMaps.CompareMode.QUESTION_MARK:
		line1.visible = false
		line2.visible = false
	else:
		line1.visible = true
		line2.visible = (
			selected_mode == SearchMaps.CompareMode.RANGE
		)


static func update_all_range_visibility(
	level_container:Node,
	scale_container:Node,
	atk_container:Node,
	def_container:Node
) -> void:

	update_range_visibility(level_container)
	update_range_visibility(scale_container)
	update_range_visibility(atk_container)
	update_range_visibility(def_container)


#
# =====================================================
# ACTIVE BUTTON HELPER
# =====================================================
#

static func _is_button_active(btn: Node) -> bool:
	if btn is TriStateButton:
		return btn.current_state != TriStateButton.State.OFF
	if btn is Button:
		return btn.button_pressed
	return false


#
# =====================================================
# PENDULUM SCALE PANEL
# =====================================================
#

static func update_pendulum_visibility(
	subtype_container:Node,
	scale_panel:Control
) -> void:

	if scale_panel == null:
		return

	scale_panel.visible = false

	if subtype_container == null:
		return

	var pendulum_button := subtype_container.find_child(
		"Pendulum",
		true,
		false
	)

	scale_panel.visible = _is_button_active(pendulum_button)


#
# =====================================================
# LINK PANEL
# =====================================================
#

static func update_link_visibility(
	type_container:Node,
	link_panel:Control
) -> void:

	if link_panel == null:
		return

	link_panel.visible = false

	if type_container == null:
		return

	var link_button := type_container.find_child(
		"Link",
		true,
		false
	)

	link_panel.visible = _is_button_active(link_button)


#
# =====================================================
# LINK ARROW COUNT
# =====================================================
#

static func update_link_arrow_count(
	link_panel:Control
) -> void:

	if link_panel == null or !link_panel.visible:
		return

	var grid := link_panel.get_node_or_null("HFlowContainer/IncludLinks/GridContainer")
	if grid == null:
		return

	var count_label := grid.get_node_or_null("Count")
	if count_label == null:
		return

	var active_count := 0

	for child in grid.get_children():
		if child is TriStateButton and child.current_state != TriStateButton.State.OFF:
			active_count += 1

	if active_count == 0:
		count_label.text = "Any"
	else:
		count_label.text = str(active_count)


#
# =====================================================
# LEVEL / RANK / LINK LABEL
# =====================================================
#

static func update_level_label(
	type_container:Node,
	label:Label
) -> void:

	if label == null:
		return

	label.text = "Level"

	if type_container == null:
		return

	var link_button := type_container.find_child(
		"Link",
		true,
		false
	)

	if _is_button_active(link_button):
		label.text = "Link"
		return

	var xyz_button := type_container.find_child(
		"Xyz",
		true,
		false
	)

	if _is_button_active(xyz_button):
		label.text = "Rank"


#
# =====================================================
# MONSTER-SPECIFIC VISIBILITY
# =====================================================
#

static func update_monster_visibility(
	type_container:Node,
	subtype_container:Node,
	link_panel:Control,
	scale_panel:Control,
	level_label:Label
) -> void:

	update_link_visibility(
		type_container,
		link_panel
	)

	update_pendulum_visibility(
		subtype_container,
		scale_panel
	)

	update_level_label(
		type_container,
		level_label
	)

	update_link_arrow_count(
		link_panel
	)


#
# =====================================================
# COMPLETE UPDATE
# =====================================================
#

static func update_all(
	main_type:int,
	monster_search:Control,
	spell_search:Control,
	trap_search:Control,

	type_container:Node,
	subtype_container:Node,

	link_panel:Control,
	scale_panel:Control,

	level_label:Label,

	level_container:Node,
	scale_container:Node,
	atk_container:Node,
	def_container:Node
) -> void:

	update_main_type(
		main_type,
		monster_search,
		spell_search,
		trap_search
	)

	update_monster_visibility(
		type_container,
		subtype_container,
		link_panel,
		scale_panel,
		level_label
	)

	update_all_range_visibility(
		level_container,
		scale_container,
		atk_container,
		def_container
	)
