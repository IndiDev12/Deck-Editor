class_name SearchVisibility1
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
# RANGE SECOND VALUE
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

	var line2 := container.find_child(
		"LineEdit2",
		true,
		false
	) as LineEdit

	if option_button == null or line2 == null:
		return

	line2.visible = (
		option_button.selected
		==
		SearchMaps.CompareMode.RANGE
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

	if pendulum_button is Button:
		scale_panel.visible = pendulum_button.button_pressed


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

	if link_button is Button:
		link_panel.visible = link_button.button_pressed


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

	if link_button is Button and link_button.button_pressed:
		label.text = "Link"
		return

	var xyz_button := type_container.find_child(
		"Xyz",
		true,
		false
	)

	if xyz_button is Button and xyz_button.button_pressed:
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


#
# =====================================================
# CONNECT OPTION BUTTONS
# =====================================================
#

static func connect_range_visibility(
	container:Node
) -> void:

	if container == null:
		return

	var option_button := container.find_child(
		"OptionButton",
		true,
		false
	) as OptionButton

	if option_button == null:
		return

	if !option_button.item_selected.is_connected(
		func(_i:int):
			update_range_visibility(container)
	):

		option_button.item_selected.connect(
			func(_i:int):
				update_range_visibility(container)
		)


#
# =====================================================
# CONNECT ALL RANGE PANELS
# =====================================================
#

static func connect_all_range_visibility(
	level_container:Node,
	scale_container:Node,
	atk_container:Node,
	def_container:Node
) -> void:

	connect_range_visibility(level_container)
	connect_range_visibility(scale_container)
	connect_range_visibility(atk_container)
	connect_range_visibility(def_container)
