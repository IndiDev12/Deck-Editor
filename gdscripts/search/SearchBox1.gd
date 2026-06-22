extends PanelContainer

signal search_finished(card_ids:Array[int])

#
# UI REFERENCES
#

@onready var text_edit: TextEdit = $FoldableContainer/VBoxContainer/TextSearch/TextEdit

@onready var name_toggle:Button = $FoldableContainer/VBoxContainer/TextSearch/Name
@onready var description_toggle:Button = $FoldableContainer/VBoxContainer/TextSearch/Description

@onready var main_card_type_select: OptionButton = \
$FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/MainCardTypeSelect

@onready var main_card_type_container: ScrollContainer = \
$FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/ScrollContainer

@onready var monster_search: Control = \
$FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/ScrollContainer/MonsterSearch

@onready var spell_search: Control = \
$FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/ScrollContainer/SpellSearch

@onready var trap_search: Control = \
$FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/ScrollContainer/TrapSearch

@onready var attribute_select = $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/ScrollContainer/MonsterSearch/VBoxContainer/AttributeSelect
@onready var race_select = $FoldableContainer/VBoxContainer/FoldableContainer/VBoxContainer/ScrollContainer/MonsterSearch/VBoxContainer/RaceTypeSelect

@onready var search_button: Button = $FoldableContainer/VBoxContainer/SearchToggle

#
# MAIN
#

func _ready():

	search_button.pressed.connect(_on_search_pressed)

	main_card_type_select.item_selected.connect(
		_on_main_card_type_changed
	)

	_on_main_card_type_changed(
		main_card_type_select.get_selected_id()
	)

func _on_main_card_type_changed(index:int) -> void:

	monster_search.visible = false
	spell_search.visible = false
	trap_search.visible = false

	match index:
		0:
			main_card_type_container.visible = true
			monster_search.visible = true

		1:
			main_card_type_container.visible = true
			spell_search.visible = true

		2:
			main_card_type_container.visible = true
			trap_search.visible = true

		3:
			main_card_type_container.visible = false


func _on_search_pressed():

	var conditions:Array[String] = []

	#
	# TEXT
	#

	conditions.append_array(
		SearchConditions.build_text_conditions(
			text_edit.text,
			name_toggle.button_pressed,
			description_toggle.button_pressed
		)
	)


	#
	# ATTRIBUTE
	#

	var attribute_values:Array[int] = []

	for child in attribute_select.get_children():

		if child is Button and child.button_pressed:
			attribute_values.append(
				SearchMaps.ATTRIBUTE_MAP[child.name]
			)

	conditions.append_array(
		SearchConditions.build_attribute_conditions(
			attribute_values
		)
	)


	#
	# RACE
	#

	var race_values:Array[int] = []

	for child in race_select.get_children():

		if child is Button and child.button_pressed:
			race_values.append(
				SearchMaps.RACE_MAP[child.name]
			)

	conditions.append_array(
		SearchConditions.build_race_conditions(
			race_values
		)
	)


	var sql := SearchConditions.assemble_query(
		conditions
	)

	print(sql)

	var rows = CardDatabase.query(sql)

	var ids:Array[int] = []

	for row in rows:
		ids.append(row.id)

	search_finished.emit(ids)
	
func get_result_ids() -> Array[int]:

	var conditions:Array[String] = []

	conditions.append_array(
		SearchConditions.build_text_conditions(
			text_edit.text,
			name_toggle.button_pressed,
			description_toggle.button_pressed
		)
	)

	var sql := SearchConditions.assemble_query(
		conditions
	)

	var rows = CardDatabase.query(sql)

	var ids:Array[int] = []

	for row in rows:
		#print(row.id)
		ids.append(row.id)

	#print(ids)
	return ids
	
