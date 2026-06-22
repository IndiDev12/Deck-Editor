class_name TrapSearchCollector
extends RefCounted


static func collect(
	trap_search: Control
) -> Array[String]:

	var conditions: Array[String] = []

	if trap_search == null:
		return conditions

	var type_select := trap_search.get_node(
        "TypeSelect"
	)

	var states = SearchControlUtils.get_tri_state_names(
		type_select
	)

	if states.include.is_empty() and states.exclude.is_empty():
		return conditions


	#
	# Trap card
	#

	conditions.append(
        "(all_datas.type & %d)!=0"
		% SearchMaps.TYPE_TRAP
	)


	#
	# Normal Trap
	#

	var extra_flags = [
		SearchMaps.TYPE_CONTINUOUS,
		SearchMaps.TYPE_COUNTER
	]

	if states.include.has("Normal"):

		for f in extra_flags:
			conditions.append(
				"(all_datas.type & %d)=0" % f
			)

	if states.exclude.has("Normal"):

		var parts: Array[String] = []
		for f in extra_flags:
			parts.append("(all_datas.type & %d)!=0" % f)
			
		conditions.append("(" + " OR ".join(parts) + ")")


	#
	# Other trap types
	#

	var inc_values: Array[int] = []
	var exc_values: Array[int] = []

	for name in states.include:

		if SearchMaps.TRAP_SUBTYPE_MAP.has(name):
			inc_values.append(SearchMaps.TRAP_SUBTYPE_MAP[name])

	for name in states.exclude:

		if SearchMaps.TRAP_SUBTYPE_MAP.has(name):
			exc_values.append(SearchMaps.TRAP_SUBTYPE_MAP[name])

	conditions.append_array(
		SearchConditions.build_subtype_conditions(
			inc_values,
			exc_values,
			false
		)
	)

	return conditions
