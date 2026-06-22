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

@onready var main_card_type_select: OptionButton = \
 $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/MainCardTypeSelect

@onready var scroll_container: ScrollContainer = \
 $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/ScrollContainer


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

	main_card_type_select.item_selected.connect(
		_on_main_card_type_changed
	)

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

		elif child is Button:

			if child != search_toggle:

				if !child.toggled.is_connected(_on_any_control_changed):

					child.toggled.connect(
						func(_pressed:bool):
							_on_any_control_changed()
					)

		elif child is OptionButton:

			if child != main_card_type_select:

				if !child.item_selected.is_connected(_on_option_changed):

					child.item_selected.connect(
						func(_index:int):
							_on_option_changed()
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
# MAIN TYPE CHANGED
# =====================================================
#

func _on_main_card_type_changed(_index:int) -> void:

	_update_visibility()
	_request_search()


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

	SearchVisibility.update_all(

		main_card_type_select.selected,

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

	var conditions: Array[String] = []


	#
	# TEXT
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

	conditions.append_array(
		SearchConditions.build_text_conditions(
			text_edit.text,
			name_state,
			desc_state
		)
	)


	#
	# MAIN CARD TYPE
	#

	conditions.append_array(
		SearchConditions.build_main_type_condition(
			main_card_type_select.selected
		)
	)


	#
	# TYPE-SPECIFIC
	#

	match main_card_type_select.selected:

		SearchMaps.MainCardType.MONSTER:
			conditions.append_array(
				MonsterSearchCollector.collect(
					monster_search
				)
			)

		SearchMaps.MainCardType.SPELL:
			conditions.append_array(
				SpellSearchCollector.collect(
					spell_search
				)
			)

		SearchMaps.MainCardType.TRAP:
			conditions.append_array(
				TrapSearchCollector.collect(
					trap_search
				)
			)

		SearchMaps.MainCardType.NONE:

			pass


	#
	# SQL
	#

	var sql := SearchConditions.assemble_query(
		conditions
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
	
	print("conditions is: ", conditions)
	
#
# =====================================================
# PUBLIC
# =====================================================

func get_result_ids() -> Array[int]:

	return last_result_ids


func refresh_search() -> void:

	_execute_search()


func clear_cache() -> void:

	query_executor.clear_cache()
