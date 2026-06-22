class_name TriStateButton
extends Button

enum State { OFF, INCLUDE, EXCLUDE }

signal state_changed(state: int, button_name: String)

var current_state: int = State.OFF
var base_text: String = ""

# StyleBoxes for background colors
var style_off: StyleBoxFlat
var style_include: StyleBoxFlat
var style_exclude: StyleBoxFlat

func _ready() -> void:
	# Disable default toggle behavior, we handle it manually
	toggle_mode = false 
	base_text = text
	
	# 1. Create StyleBoxFlat instances so they actually render a background
	style_off = _create_flat_copy()
	style_include = _create_flat_copy()
	style_exclude = _create_flat_copy()
	
	# 2. Define the background colors
	style_off.bg_color = Color(0.15, 0.15, 0.15) # Dark Grey
	style_include.bg_color = Color(0.2, 0.7, 0.2) # Greenish
	style_exclude.bg_color = Color(0.8, 0.2, 0.2) # Reddish
	
	# Make sure the background is actually drawn
	style_off.draw_center = true
	style_include.draw_center = true
	style_exclude.draw_center = true
	
	update_visuals()

# Helper to safely get a StyleBoxFlat, copying margins if possible
func _create_flat_copy() -> StyleBoxFlat:
	var new_style := StyleBoxFlat.new()
	var base_style = get_theme_stylebox("normal")
	
	if base_style is StyleBoxFlat:
		# Copy over borders, corners, and margins if it was already flat
		new_style = (base_style as StyleBoxFlat).duplicate() as StyleBoxFlat
	elif base_style is StyleBox:
		# If it's empty or texture, at least copy the margins so text doesn't jump
		new_style.content_margin_left = base_style.content_margin_left
		new_style.content_margin_right = base_style.content_margin_right
		new_style.content_margin_top = base_style.content_margin_top
		new_style.content_margin_bottom = base_style.content_margin_bottom
		new_style.corner_radius_top_left = 4
		new_style.corner_radius_top_right = 4
		new_style.corner_radius_bottom_right = 4
		new_style.corner_radius_bottom_left = 4
	
	return new_style

func _pressed() -> void:
	match current_state:
		State.OFF: current_state = State.INCLUDE
		State.INCLUDE: current_state = State.EXCLUDE
		State.EXCLUDE: current_state = State.OFF
	
	update_visuals()
	state_changed.emit(current_state, name)

func get_state() -> int:
	return current_state

func force_set_state(state: int) -> void:
	current_state = state
	update_visuals()

func update_visuals() -> void:
	text = base_text # Reset text
	
	match current_state:
		State.OFF:
			add_theme_stylebox_override("normal", style_off)
			add_theme_stylebox_override("hover", style_off) 
			add_theme_stylebox_override("pressed", style_off)
			
		State.INCLUDE:
			text = "+ " + base_text
			add_theme_stylebox_override("normal", style_include)
			add_theme_stylebox_override("hover", style_include)
			add_theme_stylebox_override("pressed", style_include)
			
		State.EXCLUDE:
			text = "- " + base_text
			add_theme_stylebox_override("normal", style_exclude)
			add_theme_stylebox_override("hover", style_exclude)
			add_theme_stylebox_override("pressed", style_exclude)
