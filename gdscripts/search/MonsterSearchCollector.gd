class_name MonsterSearchCollector
extends RefCounted


#
# =====================================================
# COLLECT
# =====================================================
#

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
	var subtype_select := vbox.get_node("SubTypeSelect")
	var race_select := vbox.get_node("RaceTypeSelect")
	var link_select := vbox.get_node("LinkSelect")

	var level_panel := vbox.get_node("LevelRankLinkValue")
	var scale_panel := vbox.get_node("PendulumScaleValue")
	var atk_panel := vbox.get_node("AtkValue")
	var def_panel := vbox.get_node("DefValue")


	#
	# Attribute
	#

	var attr_states := SearchControlUtils.get_tri_state_values(
		attribute_select,
		SearchMaps.ATTRIBUTE_MAP
	)

	conditions.append_array(
		SearchConditions.build_attribute_conditions(
			attr_states.include,
			attr_states.exclude
		)
	)


	#
	# Race
	#

	var race_states := SearchControlUtils.get_tri_state_values(
		race_select,
		SearchMaps.RACE_MAP
	)

	conditions.append_array(
		SearchConditions.build_race_conditions(
			race_states.include,
			race_states.exclude
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

	var states = SearchControlUtils.get_tri_state_names(
		type_container
	)

	var conditions: Array[String] = []
	
	#
	# Regular
	#

	if states.include.has("Regular"):

		for flag in SearchMaps.EXTRA_MONSTER_FLAGS:
			conditions.append(
				"(all_datas.type & %d)=0" % flag
			)

	if states.exclude.has("Regular"):

		var parts: Array[String] = []
		for flag in SearchMaps.EXTRA_MONSTER_FLAGS:
			parts.append("(all_datas.type & %d)!=0" % flag)
			
		conditions.append("(" + " OR ".join(parts) + ")")


	#
	# Other categories
	#

	var inc_flags: Array[int] = []
	var exc_flags: Array[int] = []

	for name in states.include:

		if name == "Regular":
			continue

		if SearchMaps.MONSTER_CATEGORY_MAP.has(name):
			inc_flags.append(SearchMaps.MONSTER_CATEGORY_MAP[name])

	for name in states.exclude:

		if name == "Regular":
			continue

		if SearchMaps.MONSTER_CATEGORY_MAP.has(name):
			exc_flags.append(SearchMaps.MONSTER_CATEGORY_MAP[name])

	conditions.append_array(
		SearchConditions.build_subtype_conditions(
			inc_flags,
			exc_flags,
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

	var states = SearchControlUtils.get_tri_state_names(
		subtype_container
	)

	var inc_values: Array[int] = []
	var exc_values: Array[int] = []

	for name in states.include:

		if name == "Normal":
			inc_values.append(SearchMaps.TYPE_NORMAL)
		elif name == "Effect":
			inc_values.append(SearchMaps.TYPE_EFFECT)
		elif SearchMaps.MONSTER_SUBTYPE_MAP.has(name):
			inc_values.append(SearchMaps.MONSTER_SUBTYPE_MAP[name])

	for name in states.exclude:

		if name == "Normal":
			exc_values.append(SearchMaps.TYPE_NORMAL)
		elif name == "Effect":
			exc_values.append(SearchMaps.TYPE_EFFECT)
		elif SearchMaps.MONSTER_SUBTYPE_MAP.has(name):
			exc_values.append(SearchMaps.MONSTER_SUBTYPE_MAP[name])

	var require_all := SearchControlUtils.require_all_subtypes(
		subtype_container
	)

	return SearchConditions.build_subtype_conditions(
		inc_values,
		exc_values,
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

	var grid_container := link_panel.get_node(
        "HFlowContainer/IncludLinks/GridContainer"
	)

	var states = SearchControlUtils.get_tri_state_values(
		grid_container,
		SearchMaps.LINK_ARROW_BITS_SHORT
	)

	return SearchConditions.build_link_arrow_conditions(
		states.include,
		states.exclude
	)
