class_name SearchVisibility
extends RefCounted


#
# =====================================================
# MAIN CARD TYPE PANELS
# =====================================================
#

static func update_main_type(
	active_tab: String,
	monster_checked: bool,
	spell_checked: bool,
	trap_checked: bool,
	monster_search: Control,
	spell_search: Control,
	trap_search: Control
) -> void:

	monster_search.visible = (active_tab == "Monster")
	spell_search.visible = (active_tab == "Spell")
	trap_search.visible = (active_tab == "Trap")
	
	# Disable options if the checkbox for that type is unchecked
	_set_panel_disabled(monster_search, !monster_checked)
	_set_panel_disabled(spell_search, !spell_checked)
	_set_panel_disabled(trap_search, !trap_checked)


static func _set_panel_disabled(panel: Control, is_disabled: bool) -> void:
	if panel == null: return
	_set_children_disabled(panel, is_disabled)


static func _set_children_disabled(node: Node, is_disabled: bool) -> void:
	if node is Button:
		(node as Button).disabled = is_disabled
	elif node is LineEdit:
		(node as LineEdit).editable = !is_disabled
	elif node is OptionButton:
		(node as OptionButton).disabled = is_disabled
	elif node is TextEdit:
		(node as TextEdit).editable = !is_disabled
		
	for child in node.get_children():
		_set_children_disabled(child, is_disabled)


#
# =====================================================
# RANGE VISIBILITY
# =====================================================
#

static func update_range_visibility(
	container: Node
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

	if selected_mode == SearchMaps.CompareMode.ANY or selected_mode == SearchMaps.CompareMode.QUESTION_MARK:
		line1.visible = false
		line2.visible = false
	else:
		line1.visible = true
		line2.visible = (
			selected_mode == SearchMaps.CompareMode.RANGE
		)


static func update_all_range_visibility(
	level_container: Node,
	scale_container: Node,
	atk_container: Node,
	def_container: Node
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
	subtype_container: Node,
	scale_panel: Control
) -> void:

	if scale_panel == null:
		return

	scale_panel.visible = true


#
# =====================================================
# LINK PANEL (Always Visible Now)
# =====================================================
#

static func update_link_visibility(
	type_container: Node,
	link_panel: Control
) -> void:

	if link_panel == null:
		return

	link_panel.visible = true


#
# =====================================================
# LINK ARROW COUNT
# =====================================================
#

static func update_link_arrow_count(
	link_panel: Control,
	level_panel: Node
) -> void:

	if link_panel == null or !link_panel.visible:
		return

	var grid := link_panel.get_node_or_null("HFlowContainer/IncludLinks/GridContainer")
	if grid == null:
		return

	var count_label := grid.get_node_or_null("Count")
	if count_label == null:
		return

	if level_panel != null:
		var option_button := level_panel.find_child("OptionButton", true, false) as OptionButton
		var line1 := level_panel.find_child("LineEdit", true, false) as LineEdit
		if option_button and line1:
			if option_button.selected == SearchMaps.CompareMode.EQUAL and !line1.text.strip_edges().is_empty():
				count_label.text = line1.text.strip_edges()
				return

	var active_count := 0

	for child in grid.get_children():
		if child is TriStateButton and child.current_state == TriStateButton.State.INCLUDE:
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
	type_container: Node,
	label: Label
) -> void:

	if label == null:
		return

	label.text = "Level/Rank/Link"


#
# =====================================================
# MONSTER-SPECIFIC VISIBILITY
# =====================================================
#

static func update_monster_visibility(
	type_container: Node,
	subtype_container: Node,
	link_panel: Control,
	scale_panel: Control,
	level_label: Label,
	level_panel: Node
) -> void:

	update_link_visibility(type_container, link_panel)
	update_pendulum_visibility(subtype_container, scale_panel)
	update_level_label(type_container, level_label)
	update_link_arrow_count(link_panel, level_panel)


#
# =====================================================
# COMPLETE UPDATE
# =====================================================
#

static func update_all(
	active_tab: String,
	monster_checked: bool,
	spell_checked: bool,
	trap_checked: bool,

	monster_search: Control,
	spell_search: Control,
	trap_search: Control,

	type_container: Node,
	subtype_container: Node,

	link_panel: Control,
	scale_panel: Control,

	level_label: Label,

	level_container: Node,
	scale_container: Node,
	atk_container: Node,
	def_container: Node
) -> void:

	update_main_type(
		active_tab,
		monster_checked,
		spell_checked,
		trap_checked,
		monster_search,
		spell_search,
		trap_search
	)

	if active_tab == "Monster":
		update_monster_visibility(
			type_container,
			subtype_container,
			link_panel,
			scale_panel,
			level_label,
			level_container
		)

	update_all_range_visibility(
		level_container,
		scale_container,
		atk_container,
		def_container
	)
