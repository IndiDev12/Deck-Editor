class_name TrapSearchCollector1
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

	var names := SearchControlUtils.get_pressed_names(
		type_select
	)

	if names.is_empty():
		return conditions


	#
	# Trap card
	#

	conditions.append(
		"(datas.type & %d)!=0"
		% SearchMaps.TYPE_TRAP
	)


	#
	# Normal Trap
	#

	if names.has("Normal"):

		conditions.append(
			"""
(
	(datas.type & %d)=0
	AND
	(datas.type & %d)=0
)
"""
			% [
				SearchMaps.TYPE_CONTINUOUS,
				SearchMaps.TYPE_COUNTER
			]
		)


	#
	# Other trap types
	#

	var values: Array[int] = []

	for name in names:

		if SearchMaps.TRAP_SUBTYPE_MAP.has(name):

			values.append(
				SearchMaps.TRAP_SUBTYPE_MAP[name]
			)

	conditions.append_array(
		SearchConditions.build_subtype_conditions(
			values,
			false
		)
	)

	return conditions
