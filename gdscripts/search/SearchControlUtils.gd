class_name SearchControlUtils
extends RefCounted


#
# =====================================================
# TRI-STATE COLLECTION (NEW)
# =====================================================
#

# Returns a dictionary: { "include": Array[int], "exclude": Array[int] }
static func get_tri_state_values(
	container: Node,
	value_map: Dictionary
) -> Dictionary:

	var include_arr: Array[int] = []
	var exclude_arr: Array[int] = []
	
	if container != null:
		_extract_tri_state_values(
			container,
			value_map,
			include_arr,
			exclude_arr
		)

	return {
		"include": include_arr,
		"exclude": exclude_arr
	}


static func _extract_tri_state_values(
	node: Node,
	value_map: Dictionary,
	inc: Array[int],
	exc: Array[int]
) -> void:

	if node is TriStateButton:
		if value_map.has(node.name):
			var value: int = value_map[node.name]
			if node.current_state == TriStateButton.State.INCLUDE:
				if !inc.has(value):
					inc.append(value)
			elif node.current_state == TriStateButton.State.EXCLUDE:
				if !exc.has(value):
					exc.append(value)
	else:
		for child in node.get_children():
			_extract_tri_state_values(
				child,
				value_map,
				inc,
				exc
			)


# Returns a dictionary: { "include": Array[String], "exclude": Array[String] }
static func get_tri_state_names(
	container: Node
) -> Dictionary:

	var include_arr: Array[String] = []
	var exclude_arr: Array[String] = []
	
	if container != null:
		_extract_tri_state_names(
			container,
			include_arr,
			exclude_arr
		)

	return {
		"include": include_arr,
		"exclude": exclude_arr
	}


static func _extract_tri_state_names(
	node: Node,
	inc: Array[String],
	exc: Array[String]
) -> void:

	if node is TriStateButton:
		if node.current_state == TriStateButton.State.INCLUDE:
			if !inc.has(node.name):
				inc.append(node.name)
		elif node.current_state == TriStateButton.State.EXCLUDE:
			if !exc.has(node.name):
				exc.append(node.name)
	else:
		for child in node.get_children():
			_extract_tri_state_names(
				child,
				inc,
				exc
			)


#
# =====================================================
# LEGACY BUTTON COLLECTION (Kept for compatibility)
# =====================================================
#

static func get_pressed_buttons(
	container: Node
) -> Array[Button]:

	var result: Array[Button] = []

	if container == null:
		return result

	_collect_pressed_buttons(
		container,
		result
	)

	return result


static func _collect_pressed_buttons(
	node: Node,
	result: Array[Button]
) -> void:

	for child in node.get_children():
		
		if child is TriStateButton:
			if child.current_state == TriStateButton.State.INCLUDE:
				result.append(child)
		elif child is Button and child.button_pressed:
			result.append(child)

		_collect_pressed_buttons(
			child,
			result
		)


#
# =====================================================
# PRESSED NAMES
# =====================================================
#

static func get_pressed_names(
	container: Node
) -> Array[String]:

	var names: Array[String] = []

	for button in get_pressed_buttons(container):
		names.append(button.name)

	return names


#
# =====================================================
# PRESSED VALUES FROM MAP
# =====================================================
#

static func get_pressed_values(
	container: Node,
	value_map: Dictionary
) -> Array[int]:

	var values: Array[int] = []

	for button in get_pressed_buttons(container):

		if value_map.has(button.name):

			var value: int = value_map[button.name]

			if !values.has(value):
				values.append(value)

	return values


#
# =====================================================
# PRESSED BUTTON EXISTS
# =====================================================
#

static func is_pressed(
	container: Node,
	button_name: String
) -> bool:

	if container == null:
		return false

	var button := container.find_child(
		button_name,
		true,
		false
	)

	if button is TriStateButton:
		return button.current_state == TriStateButton.State.INCLUDE

	if button is Button:
		return button.button_pressed

	return false


#
# =====================================================
# FIND BUTTON
# =====================================================
#

static func get_button(
	container: Node,
	button_name: String
) -> Button:

	if container == null:
		return null

	var node := container.find_child(
		button_name,
		true,
		false
	)

	if node is Button:
		return node

	return null


#
# =====================================================
# LINE EDIT INTEGER
# =====================================================
#

static func line_edit_int(
	edit: LineEdit
) -> int:

	if edit == null:
		return -1

	var text := edit.text.strip_edges()

	if text.is_empty():
		return -1 # Use -1 to represent empty/ignored

	if !text.is_valid_int():
		return -1

	return text.to_int()


#
# =====================================================
# TEXT EDIT TEXT
# =====================================================
#

static func text_edit_string(
	edit: TextEdit
) -> String:

	if edit == null:
		return ""

	return edit.text.strip_edges()


#
# =====================================================
# OPTION BUTTON MODE
# =====================================================
#

static func option_mode(
	option_button: OptionButton
) -> int:

	if option_button == null:
		return SearchMaps.CompareMode.ANY

	return option_button.selected


#
# =====================================================
# RANGE VALUES
# =====================================================
#

static func get_range_values(
	container: Node
) -> Dictionary:

	if container == null:
		return {
			"mode": SearchMaps.CompareMode.ANY,
			"value1": 0,
			"value2": 0
		}

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

	return {
		"mode": option_mode(option_button),
		"value1": line_edit_int(line1),
		"value2": line_edit_int(line2)
	}


#
# =====================================================
# LINK ARROW MASK (Legacy - Replaced by get_tri_state_values)
# =====================================================
#

static func get_link_arrow_mask(
	container: Node
) -> int:

	if container == null:
		return 0

	var mask := 0

	for button in get_pressed_buttons(container):

		match button.name:

			"bl":
				mask |= SearchMaps.LINK_ARROW_BITS["BottomLeft"]

			"b":
				mask |= SearchMaps.LINK_ARROW_BITS["Bottom"]

			"br":
				mask |= SearchMaps.LINK_ARROW_BITS["BottomRight"]

			"l":
				mask |= SearchMaps.LINK_ARROW_BITS["Left"]

			"r":
				mask |= SearchMaps.LINK_ARROW_BITS["Right"]

			"tl":
				mask |= SearchMaps.LINK_ARROW_BITS["TopLeft"]

			"t":
				mask |= SearchMaps.LINK_ARROW_BITS["Top"]

			"tr":
				mask |= SearchMaps.LINK_ARROW_BITS["TopRight"]

	return mask


#
# =====================================================
# SUBTYPE MATCH MODE
# =====================================================
#

static func require_all_subtypes(
	subtype_container: Node
) -> bool:

	if subtype_container == null:
		return false

	var button := subtype_container.find_child(
		"InOneCard",
		true,
		false
	)

	if button is TriStateButton:
		return button.current_state == TriStateButton.State.INCLUDE

	if button is Button:
		return button.button_pressed

	return false


#
# =====================================================
# HAS ANY FILTER
# =====================================================
#

static func has_any_pressed_button(
	container: Node
) -> bool:

	return !get_pressed_buttons(container).is_empty()


#
# =====================================================
# SAFE ARRAY INT
# =====================================================
#

static func to_int_array(
	array: Array
) -> Array[int]:

	var result: Array[int] = []

	for value in array:

		if value is int:
			result.append(value)

	return result


#
# =====================================================
# SAFE ARRAY STRING
# =====================================================
#

static func to_string_array(
	array: Array
) -> Array[String]:

	var result: Array[String] = []

	for value in array:

		if value is String:
			result.append(value)

	return result


#
# =====================================================
# REMOVE BUTTONS FROM NAME LIST
# =====================================================
#

static func remove_names(
	names: Array[String],
	excluded: Array[String]
) -> Array[String]:

	var result: Array[String] = []

	for name in names:

		if !excluded.has(name):
			result.append(name)

	return result


#
# =====================================================
# GET BUTTONS AS DICTIONARY
# =====================================================
#

static func get_pressed_dictionary(
	container: Node
) -> Dictionary:

	var dict := {}

	for button in get_pressed_buttons(container):
		dict[button.name] = true

	return dict
