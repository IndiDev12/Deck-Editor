class_name SpellSearchCollector1
extends RefCounted


static func collect(
	spell_search: Control
) -> Array[String]:

	var conditions: Array[String] = []

	if spell_search == null:
		return conditions

	var type_select := spell_search.get_node(
		"TypeSelect"
	)

	var names := SearchControlUtils.get_pressed_names(
		type_select
	)

	if names.is_empty():
		return conditions


	#
	# Spell card
	#

	conditions.append(
		"(datas.type & %d)!=0"
		% SearchMaps.TYPE_SPELL
	)


	#
	# Normal Spell
	#

	if names.has("Normal"):

		conditions.append(
			"""
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
"""
			% [
				SearchMaps.TYPE_QUICKPLAY,
				SearchMaps.TYPE_CONTINUOUS,
				SearchMaps.TYPE_EQUIP,
				SearchMaps.TYPE_FIELD,
				SearchMaps.TYPE_RITUAL
			]
		)


	#
	# Other spell types
	#

	var values: Array[int] = []

	for name in names:

		if SearchMaps.SPELL_SUBTYPE_MAP.has(name):

			values.append(
				SearchMaps.SPELL_SUBTYPE_MAP[name]
			)

	conditions.append_array(
		SearchConditions.build_subtype_conditions(
			values,
			false
		)
	)

	return conditions
