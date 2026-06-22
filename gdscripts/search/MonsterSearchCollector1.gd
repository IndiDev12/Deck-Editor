class_name MonsterSearchCollector1
extends RefCounted





static func collect(
	monster_search: Control
) -> Array[String]:

	var conditions: Array[String] = []

	if monster_search == null:
		return conditions


	#
	# Containers
	#

	var vbox := monster_search.get_node("VBoxContainer")

	var attribute_select := vbox.get_node("AttributeSelect")
	var type_select := vbox.get_node("TypeSelect")
	print("type_select node =", type_select)
	var subtype_select := vbox.get_node("SubTypeSelect")
	var race_select := vbox.get_node("RaceTypeSelect")
	var link_select := vbox.get_node("LinkSelect")
	print("link_select node =", link_select)

	var level_panel := vbox.get_node("LevelRankLinkValue")
	var scale_panel := vbox.get_node("PendulumScaleValue")
	var atk_panel := vbox.get_node("AtkValue")
	var def_panel := vbox.get_node("DefValue")


	#
	# Attribute
	#

	var attribute_values := SearchControlUtils.get_pressed_values(
		attribute_select,
		SearchMaps.ATTRIBUTE_MAP
	)

	conditions.append_array(
		SearchConditions.build_attribute_conditions(
			attribute_values
		)
	)


	#
	# Race
	#

	var race_values := SearchControlUtils.get_pressed_values(
		race_select,
		SearchMaps.RACE_MAP
	)

	conditions.append_array(
		SearchConditions.build_race_conditions(
			race_values
		)
	)


	#
	# Monster categories
	#

	conditions.append_array(
		_collect_type_conditions(
			type_select
		)
	)


	#
	# Subtypes
	#

	conditions.append_array(
		_collect_subtype_conditions(
			subtype_select
		)
	)


	#
	# Link arrows
	#

	conditions.append_array(
		_collect_link_conditions(
			link_select
		)
	)


	#
	# Level / Rank / Link rating
	#

	var level_values := SearchControlUtils.get_range_values(
		level_panel
	)

	conditions.append_array(
		SearchConditions.build_level_conditions(
			level_values.mode,
			level_values.value1,
			level_values.value2
		)
	)


	#
	# Pendulum scale
	#

	var scale_values := SearchControlUtils.get_range_values(
		scale_panel
	)

	conditions.append_array(
		SearchConditions.build_scale_conditions(
			scale_values.mode,
			scale_values.value1,
			scale_values.value2
		)
	)


	#
	# ATK
	#

	var atk_values := SearchControlUtils.get_range_values(
		atk_panel
	)

	conditions.append_array(
		SearchConditions.build_atk_conditions(
			atk_values.mode,
			atk_values.value1,
			atk_values.value2
		)
	)


	#
	# DEF
	#

	var def_values := SearchControlUtils.get_range_values(
		def_panel
	)

	conditions.append_array(
		SearchConditions.build_def_conditions(
			def_values.mode,
			def_values.value1,
			def_values.value2
		)
	)

	return conditions



#
# -----------------------------------------------------
# Type section
# -----------------------------------------------------
#

static func _collect_type_conditions(
	type_container: Node
) -> Array[String]:

	var conditions: Array[String] = []

	var names := SearchControlUtils.get_pressed_names(
		type_container
	)

	print("TypeSelect pressed names: ", names)

	#
	# Regular
	#

	if names.has("Regular"):

		conditions.append(
			"""
(
	(
	(datas.type & %d)=0
	AND
	(datas.type & %d)=0
	AND
	(datas.type & %d)=0
	AND
	(datas.type & %d)=0
	AND
	(datas.type & %d)=0
	)
)
""" % [
				SearchMaps.TYPE_RITUAL,
				SearchMaps.TYPE_FUSION,
				SearchMaps.TYPE_SYNCHRO,
				SearchMaps.TYPE_XYZ,
				SearchMaps.TYPE_LINK
			]
		)


	#
	# Other categories
	#

	var flags: Array[int] = []

	for name in names:

		if SearchMaps.MONSTER_CATEGORY_MAP.has(name):

			flags.append(
				SearchMaps.MONSTER_CATEGORY_MAP[name]
			)



	#if names.has("Ritual"):
		#flags.append(SearchMaps.TYPE_RITUAL)
#
	#if names.has("Fusion"):
		#flags.append(SearchMaps.TYPE_FUSION)
#
	#if names.has("Synchro"):
		#flags.append(SearchMaps.TYPE_SYNCHRO)
#
	#if names.has("Xyz"):
		#flags.append(SearchMaps.TYPE_XYZ)
#
	#if names.has("Link"):
		#flags.append(SearchMaps.TYPE_LINK)
#
	#if names.has("Token"):
		#flags.append(SearchMaps.TYPE_TOKEN)


	conditions.append_array(
		SearchConditions.build_subtype_conditions(
			flags,
			false
		)
	)

	return conditions



#
# -----------------------------------------------------
# Subtypes
# -----------------------------------------------------
#

static func _collect_subtype_conditions(
	subtype_container: Node
) -> Array[String]:

	var names := SearchControlUtils.get_pressed_names(
		subtype_container
	)
	
	print("Subtype pressed names: ", names)

	names = SearchControlUtils.remove_names(
		names,
		[
			"InOneCard",
			"Multiple"
		]
	)

	var values: Array[int] = []

	for name in names:

		if SearchMaps.MONSTER_SUBTYPE_MAP.has(name):

			values.append(
				SearchMaps.MONSTER_SUBTYPE_MAP[name]
			)

	var require_all := SearchControlUtils.require_all_subtypes(
		subtype_container
	)

	print("Subtype values: ", values)

	return SearchConditions.build_subtype_conditions(
		values,
		require_all
	)



#
# -----------------------------------------------------
# Link arrows
# -----------------------------------------------------
#

static func _collect_link_conditions(
	link_panel: Node
) -> Array[String]:

	var include_panel := link_panel.get_node(
		"HFlowContainer/IncludLinks/GridContainer"
	)

	var exclude_panel := link_panel.get_node(
		"HFlowContainer/ExcludLinks/GridContainer"
	)

	var include_mask := SearchControlUtils.get_link_arrow_mask(
		include_panel
	)

	var exclude_mask := SearchControlUtils.get_link_arrow_mask(
		exclude_panel
	)

	var include_arrows: Array[int] = []
	var exclude_arrows: Array[int] = []

	if include_mask != 0:
		include_arrows.append(include_mask)

	if exclude_mask != 0:
		exclude_arrows.append(exclude_mask)

	return SearchConditions.build_link_arrow_conditions(
		include_arrows,
		exclude_arrows
	)
