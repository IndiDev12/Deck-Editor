extends PanelContainer

signal search_finished(card_ids:Array[int])


#
# =====================================================
# STATE
# =====================================================
#

var last_result_ids: Array[int] = []
var query_executor := SearchQueryExecutor.new()


#
# =====================================================
# TEXT SEARCH
# =====================================================
#

@onready var text_edit: TextEdit = \
 $FoldableContainer/VBoxContainer/TextSearch/TextEdit

@onready var name_toggle: Button = \
 $FoldableContainer/VBoxContainer/TextSearch/Name

@onready var description_toggle: Button = \
 $FoldableContainer/VBoxContainer/TextSearch/Description


#
# =====================================================
# GENERAL
# =====================================================
#

@onready var search_toggle: Button = \
 $FoldableContainer/VBoxContainer/SearchToggle

@onready var main_type_tabs: HBoxContainer = \
 $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/MainCardTypeSelectTabs

@onready var monster_checkbox: CheckBox = $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/MainCardTypeSelectTabs/MonsterCheckBox
@onready var spell_checkbox: CheckBox = $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/MainCardTypeSelectTabs/SpellCheckBox
@onready var trap_checkbox: CheckBox = $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/MainCardTypeSelectTabs/TrapCheckBox


@onready var monster_tab: Button = main_type_tabs.get_node("Monster")
@onready var spell_tab: Button = main_type_tabs.get_node("Spell")
@onready var trap_tab: Button = main_type_tabs.get_node("Trap")

@onready var scroll_container: ScrollContainer = \
 $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/ScrollContainer


#
# =====================================================
# BANLIST & OT
# =====================================================
#

@onready var ban_select: Control = \
 $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/BanSelect

@onready var ot_select: Control = \
 $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/OtSelect


#
# =====================================================
# MAIN PANELS
# =====================================================
#

@onready var monster_search: Control = \
scroll_container.get_node("MonsterSearch")

@onready var spell_search: Control = \
scroll_container.get_node("SpellSearch")

@onready var trap_search: Control = \
scroll_container.get_node("TrapSearch")


#
# =====================================================
# MONSTER PANELS
# =====================================================
#

@onready var monster_vbox: VBoxContainer = \
monster_search.get_node("VBoxContainer")

@onready var attribute_select: Control = \
monster_vbox.get_node("AttributeSelect")

@onready var type_select: Control = \
monster_vbox.get_node("TypeSelect")

@onready var subtype_select: Control = \
monster_vbox.get_node("SubTypeSelect")

@onready var race_select: Control = \
monster_vbox.get_node("RaceTypeSelect")

@onready var link_select: Control = \
monster_vbox.get_node("LinkSelect")


#
# =====================================================
# NUMERIC PANELS
# =====================================================
#

@onready var level_panel: PanelContainer = \
monster_vbox.get_node("LevelRankLinkValue")

@onready var scale_panel: PanelContainer = \
monster_vbox.get_node("PendulumScaleValue")

@onready var atk_panel: PanelContainer = \
monster_vbox.get_node("AtkValue")

@onready var def_panel: PanelContainer = \
monster_vbox.get_node("DefValue")


#
# =====================================================
# LEVEL LABEL
# =====================================================
#

@onready var level_label: Label = \
level_panel.get_node("HBoxContainer/Label2")


#
# =====================================================
# SPELL PANEL
# =====================================================
#

@onready var spell_type_select: Control = \
spell_search.get_node("TypeSelect")


#
# =====================================================
# TRAP PANEL
# =====================================================
#

@onready var trap_type_select: Control = \
trap_search.get_node("TypeSelect")

#
# =====================================================
# READY
# =====================================================
#

func _ready() -> void:

	search_toggle.toggled.connect(
		_on_search_toggle_toggled
	)

	_connect_recursive(self)

	_update_visibility()

	if search_toggle.button_pressed:
		_execute_search()


#
# =====================================================
# RECURSIVE CONNECTION
# =====================================================
#

func _connect_recursive(node:Node) -> void:

	for child in node.get_children():

		if child is TriStateButton:

			if !child.state_changed.is_connected(_on_any_control_changed):

				child.state_changed.connect(
					func(_state:int, _name:String):
						_on_any_control_changed()
				)

		# OptionButton extends Button, so it MUST be checked first!
		elif child is OptionButton:

			if !child.item_selected.is_connected(_on_option_changed):

				child.item_selected.connect(
					func(_index:int):
						_on_option_changed()
				)

		elif child is Button:

			if child != search_toggle:

				if !child.toggled.is_connected(_on_any_control_changed):

					child.toggled.connect(
						func(_pressed:bool):
							_on_any_control_changed()
					)

		elif child is LineEdit:

			if !child.text_changed.is_connected(_on_line_edit_changed):

				child.text_changed.connect(
					func(_text:String):
						_on_line_edit_changed()
				)

		elif child is TextEdit:

			if !child.text_changed.is_connected(_on_text_edit_changed):

				child.text_changed.connect(
					func():
						_on_text_edit_changed()
				)

		_connect_recursive(child)


#
# =====================================================
# SEARCH TOGGLE
# =====================================================
#

func _on_search_toggle_toggled(enabled:bool) -> void:

	if enabled:
		_execute_search()


#
# =====================================================
# GENERIC UI CHANGE
# =====================================================
#

func _on_any_control_changed() -> void:

	_update_visibility()
	_request_search()


func _on_option_changed() -> void:

	_update_visibility()
	_request_search()


func _on_line_edit_changed() -> void:

	_request_search()


func _on_text_edit_changed() -> void:

	_request_search()


#
# =====================================================
# REQUEST SEARCH
# =====================================================
#

func _request_search() -> void:

	if search_toggle.button_pressed:

		_execute_search()


#
# =====================================================
# VISIBILITY
# =====================================================
#

func _update_visibility() -> void:

	var active_tab := "Monster"
	if monster_tab.button_pressed:
		active_tab = "Monster"
	elif spell_tab.button_pressed:
		active_tab = "Spell"
	elif trap_tab.button_pressed:
		active_tab = "Trap"

	SearchVisibility.update_all(

		active_tab,
		monster_checkbox.button_pressed,
		spell_checkbox.button_pressed,
		trap_checkbox.button_pressed,

		monster_search,
		spell_search,
		trap_search,

		type_select,
		subtype_select,

		link_select,
		scale_panel,

		level_label,

		level_panel,
		scale_panel,
		atk_panel,
		def_panel
	)


#
# =====================================================
# SEARCH
# =====================================================
#

func _execute_search() -> void:

	var global_conditions: Array[String] = []


	#
	# TEXT (Global)
	#

	var name_state: int = TriStateButton.State.OFF
	var desc_state: int = TriStateButton.State.OFF

	if name_toggle is TriStateButton:
		name_state = name_toggle.current_state
	elif name_toggle is Button:
		name_state = TriStateButton.State.INCLUDE if name_toggle.button_pressed else TriStateButton.State.OFF

	if description_toggle is TriStateButton:
		desc_state = description_toggle.current_state
	elif description_toggle is Button:
		desc_state = TriStateButton.State.INCLUDE if description_toggle.button_pressed else TriStateButton.State.OFF

	global_conditions.append_array(
		SearchConditions.build_text_conditions(
			text_edit.text,
			name_state,
			desc_state
		)
	)


	#
	# BANLIST (Global)
	#

	if ban_select != null:
		var ban_states := SearchControlUtils.get_tri_state_values(
			ban_select,
			SearchMaps.BAN_MAP
		)
		global_conditions.append_array(
			SearchConditions.build_ban_conditions(
				ban_states.include,
				ban_states.exclude
			)
		)


	#
	# OT (Global)
	#

	if ot_select != null:
		var ot_states := SearchControlUtils.get_tri_state_values(
			ot_select,
			SearchMaps.OT_MAP
		)
		global_conditions.append_array(
			SearchConditions.build_ot_conditions(
				ot_states.include,
				ot_states.exclude
			)
		)


	#
	# MAIN CARD TYPE (Separated into OR blocks to prevent conflicts)
	#

	var m_checked = monster_checkbox.button_pressed
	var s_checked = spell_checkbox.button_pressed
	var t_checked = trap_checkbox.button_pressed
	
	var type_blocks: Array[String] = []

	if m_checked:
		var m_conds: Array[String] = []
		m_conds.append("(all_datas.type & %d)!=0" % SearchMaps.TYPE_MONSTER)
		m_conds.append_array(MonsterSearchCollector.collect(monster_search))
		# Join all monster conditions with AND, and wrap in parentheses
		type_blocks.append("(" + " AND ".join(m_conds) + ")")

	if s_checked:
		var s_conds: Array[String] = []
		s_conds.append("(all_datas.type & %d)!=0" % SearchMaps.TYPE_SPELL)
		s_conds.append_array(SpellSearchCollector.collect(spell_search))
		type_blocks.append("(" + " AND ".join(s_conds) + ")")

	if t_checked:
		var t_conds: Array[String] = []
		t_conds.append("(all_datas.type & %d)!=0" % SearchMaps.TYPE_TRAP)
		t_conds.append_array(TrapSearchCollector.collect(trap_search))
		type_blocks.append("(" + " AND ".join(t_conds) + ")")

	# Combine the separated blocks with OR
	if !type_blocks.is_empty():
		global_conditions.append("(" + " OR ".join(type_blocks) + ")")


	#
	# SQL
	#

	var sql := SearchConditions.assemble_query(
		global_conditions
	)


	#
	# QUERY
	#

	var ids := query_executor.execute(
		sql
	)


	#
	# STORE
	#

	last_result_ids = ids


	#
	# SIGNAL
	#

	search_finished.emit(
		ids
	)

	print("conditions is: ", global_conditions)


#
# =====================================================
# PUBLIC
# =====================================================
#

func get_result_ids() -> Array[int]:

	return last_result_ids


func refresh_search() -> void:

	_execute_search()


func clear_cache() -> void:

	query_executor.clear_cache()
