class_name SearchConditions2
extends RefCounted


enum CompareMode {
	EQUAL,
	NOT_EQUAL,
	GREATER,
	GREATER_EQUAL,
	LESS,
	LESS_EQUAL,
	RANGE
}


#
# =====================================================
# Helpers
# =====================================================
#

static func _or_equals(
	column:String,
	values:Array
) -> Array[String]:

	if values.is_empty():
		return []

	var parts:Array[String] = []

	for value in values:

		if value is String:
			value = value.replace("'", "''")
			parts.append("%s='%s'" % [column, value])

		else:
			parts.append("%s=%s" % [column, str(value)])

	return ["(" + " OR ".join(parts) + ")"]


static func _or_flags(
	column:String,
	values:Array[int]
) -> Array[String]:

	if values.is_empty():
		return []

	var parts:Array[String] = []

	for value in values:
		parts.append("(%s & %d)!=0" % [column, value])

	return ["(" + " OR ".join(parts) + ")"]


static func _all_flags(
	column:String,
	values:Array[int]
) -> Array[String]:

	if values.is_empty():
		return []

	var parts:Array[String] = []

	for value in values:
		parts.append("(%s & %d)!=0" % [column, value])

	return ["(" + " AND ".join(parts) + ")"]


#
# =====================================================
# Text
# =====================================================
#

static func build_text_conditions(
	keyword:String,
	search_name:bool,
	search_description:bool
) -> Array[String]:

	keyword = keyword.strip_edges()

	if keyword.is_empty():
		return []

	keyword = keyword.replace("'", "''")

	var parts:Array[String] = []

	if search_name:
		parts.append("texts.name LIKE '%%%s%%'" % keyword)

	if search_description:
		parts.append("texts.desc LIKE '%%%s%%'" % keyword)

	if parts.is_empty():
		return []

	return ["(" + " OR ".join(parts) + ")"]


#
# =====================================================
# Attribute
# =====================================================
#

static func build_attribute_conditions(
	values:Array[int]
) -> Array[String]:

	return _or_equals(
		"datas.attribute",
		values
	)


#
# =====================================================
# Race
# =====================================================
#

static func build_race_conditions(
	values:Array[int]
) -> Array[String]:

	return _or_flags(
		"datas.race",
		values
	)


#
# =====================================================
# Main card type
# =====================================================
#

static func build_main_type_condition(
	main_type:int
) -> Array[String]:

	match main_type:

		SearchMaps.MainCardType.MONSTER:
			return ["(datas.type & %d)!=0" % SearchMaps.TYPE_MONSTER]

		SearchMaps.MainCardType.SPELL:
			return ["(datas.type & %d)!=0" % SearchMaps.TYPE_SPELL]

		SearchMaps.MainCardType.TRAP:
			return ["(datas.type & %d)!=0" % SearchMaps.TYPE_TRAP]

	return []


#
# =====================================================
# Monster subtypes
# =====================================================
#

static func build_subtype_conditions(
	selected:Array[int],
	require_all:bool
) -> Array[String]:

	if selected.is_empty():
		return []

	if require_all:
		return _all_flags("datas.type", selected)

	return _or_flags("datas.type", selected)


#
# =====================================================
# Normal/Effect base type monsters
# =====================================================
#

static func build_normal_effect_conditions(
	has_normal: bool,
	has_effect: bool,
	require_all: bool
) -> Array[String]:

	#
	# Neither selected
	#

	if !has_normal and !has_effect:
		return []


	#
	# Both selected
	#

	if has_normal and has_effect:

		if require_all:

			# impossible
			return ["(1=0)"]

		else:

			# any monster (normal or effect)
			return []


	#
	# Normal only
	#

	if has_normal:

		return [
			"(datas.type & %d)=0"
			% SearchMaps.TYPE_EFFECT
		]


	#
	# Effect only
	#

	return [
		"(datas.type & %d)!=0"
		% SearchMaps.TYPE_EFFECT
	]




#
# =====================================================
# Normal base type monsters
# =====================================================
#

#static func build_normal_condition() -> Array[String]:
#
	#return [
		#"(datas.type & %d)=0" % SearchMaps.TYPE_EFFECT
	#]

#
# =====================================================
# Effect base type monsters
# =====================================================
#


#static func build_effect_condition() -> Array[String]:
#
	#return [
		#"(datas.type & %d)!=0" % SearchMaps.TYPE_EFFECT
	#]


#
# =====================================================
# Regular monsters
# =====================================================
#

static func build_regular_monster_condition() -> Array[String]:

	var conditions:Array[String] = []

	for flag in SearchMaps.EXTRA_MONSTER_FLAGS:
		conditions.append(
			"(datas.type & %d)=0" % flag
		)

	return conditions


#
# =====================================================
# Numbers
# =====================================================
#

static func build_number_condition(
	column:String,
	mode:int,
	value1:int,
	value2:int
) -> Array[String]:

	match mode:

		CompareMode.EQUAL:
			if value1 != 0:
				return ["%s=%d" % [column, value1]]

		CompareMode.NOT_EQUAL:
			if value1 != 0:
				return ["%s!=%d" % [column, value1]]

		CompareMode.GREATER:
			if value1 != 0:
				return ["%s>%d" % [column, value1]]

		CompareMode.GREATER_EQUAL:
			if value1 != 0:
				return ["%s>=%d" % [column, value1]]

		CompareMode.LESS:
			if value1 != 0:
				return ["%s<%d" % [column, value1]]

		CompareMode.LESS_EQUAL:
			if value1 != 0:
				return ["%s<=%d" % [column, value1]]

		CompareMode.RANGE:

			if value1 == 0 and value2 == 0:
				return []

			if value1 == 0:
				value1 = -999999

			if value2 == 0:
				value2 = 999999

			return [
				"(%s BETWEEN %d AND %d)"
				% [column, value1, value2]
			]

	return []


#
# =====================================================
# Level / Rank / Link Rating
# =====================================================
#

static func build_level_conditions(
	mode:int,
	value1:int,
	value2:int
) -> Array[String]:

	return build_number_condition(
		"datas.level & 255",
		mode,
		value1,
		value2
	)


#
# =====================================================
# Pendulum scale
# =====================================================
#

static func build_scale_conditions(
	mode:int,
	value1:int,
	value2:int
) -> Array[String]:

	return build_number_condition(
		"(datas.level >> 24) & 255",
		mode,
		value1,
		value2
	)


#
# =====================================================
# ATK
# =====================================================
#

static func build_atk_conditions(
	mode:int,
	value1:int,
	value2:int
) -> Array[String]:

	return build_number_condition(
		"datas.atk",
		mode,
		value1,
		value2
	)


#
# =====================================================
# DEF
# =====================================================
#

static func build_def_conditions(
	mode:int,
	value1:int,
	value2:int
) -> Array[String]:

	return build_number_condition(
		"datas.def",
		mode,
		value1,
		value2
	)


#
# =====================================================
# Link arrows
# =====================================================
#


static func build_link_arrow_conditions(
	include_arrows:Array[int],
	exclude_arrows:Array[int]
) -> Array[String]:

	var conditions:Array[String] = []

	# No arrows selected → no condition
	if include_arrows.is_empty() and exclude_arrows.is_empty():
		return conditions


	# Arrow search implies Link monster
	conditions.append(
		"(datas.type & %d)!=0"
		% SearchMaps.TYPE_LINK
	)


	if !include_arrows.is_empty():

		var mask := 0

		for arrow in include_arrows:
			mask |= arrow

		conditions.append(
			"(datas.def & %d)=%d"
			% [mask, mask]
		)


	if !exclude_arrows.is_empty():

		var mask := 0

		for arrow in exclude_arrows:
			mask |= arrow

		conditions.append(
			"(datas.def & %d)=0"
			% mask
		)


	return conditions



#static func build_link_arrow_conditions(
	#include_arrows:Array[int],
	#exclude_arrows:Array[int]
#) -> Array[String]:
#
	#var conditions:Array[String] = []
#
	#conditions.append(
		#"(datas.type & %d)!=0"
		#% SearchMaps.TYPE_LINK
	#)
#
	#if !include_arrows.is_empty():
#
		#var mask := 0
#
		#for arrow in include_arrows:
			#mask |= arrow
#
		#conditions.append(
			#"(datas.def & %d)=%d"
			#% [mask, mask]
		#)
#
	#if !exclude_arrows.is_empty():
#
		#var mask := 0
#
		#for arrow in exclude_arrows:
			#mask |= arrow
#
		#conditions.append(
			#"(datas.def & %d)=0"
			#% mask
		#)
#
	#return conditions


#
# =====================================================
# OT
# =====================================================
#

static func build_ot_conditions(
	selected:Array[String]
) -> Array[String]:

	return _or_equals(
		"datas.ot",
		selected
	)


#
# =====================================================
# Banlist
# =====================================================
#

static func build_ban_conditions(
	selected:Array[int]
) -> Array[String]:

	return _or_equals(
		"datas.banlist",
		selected
	)


#
# =====================================================
# Card IDs
# =====================================================
#

static func build_special_card_conditions(
	ids:Array[int]
) -> Array[String]:

	return _or_equals(
		"datas.id",
		ids
	)


#
# =====================================================
# Query
# =====================================================
#

static func assemble_query(
	conditions:Array[String]
) -> String:

	var sql := """
SELECT datas.id
FROM datas
JOIN texts
ON datas.id=texts.id
"""

	if !conditions.is_empty():

		sql += "\nWHERE\n"
		sql += "\nAND\n".join(conditions)

	sql += "\nORDER BY texts.name"

	return sql
