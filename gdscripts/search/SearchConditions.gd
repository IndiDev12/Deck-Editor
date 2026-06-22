class_name SearchConditions
extends RefCounted


enum CompareMode {
	EQUAL,
	NOT_EQUAL,
	GREATER,
	GREATER_EQUAL,
	LESS,
	LESS_EQUAL,
	RANGE,
	ANY,
	QUESTION_MARK
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
	name_state:int,
	desc_state:int
) -> Array[String]:

	keyword = keyword.strip_edges()

	if keyword.is_empty():
		return []

	keyword = keyword.replace("'", "''")

	var parts:Array[String] = []

	# Name Search
	if name_state == TriStateButton.State.INCLUDE:
		parts.append("all_texts.name LIKE '%%%s%%'" % keyword)
	elif name_state == TriStateButton.State.EXCLUDE:
		parts.append("all_texts.name NOT LIKE '%%%s%%'" % keyword)
		
	# Description Search
	if desc_state == TriStateButton.State.INCLUDE:
		parts.append("all_texts.desc LIKE '%%%s%%'" % keyword)
	elif desc_state == TriStateButton.State.EXCLUDE:
		parts.append("all_texts.desc NOT LIKE '%%%s%%'" % keyword)

	if parts.is_empty():
		return []

	return ["(" + " OR ".join(parts) + ")"]


#
# =====================================================
# Attribute
# =====================================================
#

static func build_attribute_conditions(
	inc:Array,
	exc:Array
) -> Array[String]:

	var conditions:Array[String] = []

	if !inc.is_empty():
		conditions.append_array(_or_equals("all_datas.attribute", inc))

	if !exc.is_empty():
		var parts:Array[String] = []
		for v in exc:
			parts.append("all_datas.attribute != %s" % str(v))
		conditions.append("(" + " AND ".join(parts) + ")")

	return conditions


#
# =====================================================
# Race
# =====================================================
#

static func build_race_conditions(
	inc:Array,
	exc:Array
) -> Array[String]:

	var conditions:Array[String] = []

	if !inc.is_empty():
		conditions.append_array(_or_flags("all_datas.race", inc))

	if !exc.is_empty():
		var parts:Array[String] = []
		for v in exc:
			parts.append("(all_datas.race & %d)=0" % v)
		conditions.append("(" + " AND ".join(parts) + ")")

	return conditions


#
# =====================================================
# Monster subtypes (and general type flags)
# =====================================================
#

static func build_subtype_conditions(
	inc:Array[int],
	exc:Array[int],
	require_all:bool
) -> Array[String]:

	var conditions:Array[String] = []

	if !inc.is_empty():
		if require_all:
			conditions.append_array(_all_flags("all_datas.type", inc))
		else:
			conditions.append_array(_or_flags("all_datas.type", inc))

	if !exc.is_empty():
		var parts:Array[String] = []
		for v in exc:
			parts.append("(all_datas.type & %d)=0" % v)
		conditions.append("(" + " AND ".join(parts) + ")")

	return conditions


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

	if !has_normal and !has_effect:
		return []

	if has_normal and has_effect:
		if require_all:
			return ["(1=0)"]
		else:
			return []

	if has_normal:
		return [
            "(all_datas.type & %d)=0"
			% SearchMaps.TYPE_EFFECT
		]

	return [
        "(all_datas.type & %d)!=0"
		% SearchMaps.TYPE_EFFECT
	]


#
# =====================================================
# Regular monsters
# =====================================================
#

static func build_regular_monster_condition() -> Array[String]:

	var conditions:Array[String] = []

	for flag in SearchMaps.EXTRA_MONSTER_FLAGS:
		conditions.append(
			"(all_datas.type & %d)=0" % flag
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

	if value1 == -1 and (mode != CompareMode.RANGE or value2 == -1):
		
		if mode == CompareMode.QUESTION_MARK:
			return ["%s=-2" % column]
		elif mode == CompareMode.ANY:
			return []
			
		return []

	match mode:

		CompareMode.EQUAL:
			return ["%s=%d" % [column, value1]]

		CompareMode.NOT_EQUAL:
			return ["%s!=%d" % [column, value1]]

		CompareMode.GREATER:
			return ["%s>%d" % [column, value1]]

		CompareMode.GREATER_EQUAL:
			return ["%s>=%d" % [column, value1]]

		CompareMode.LESS:
			return ["%s<%d" % [column, value1]]

		CompareMode.LESS_EQUAL:
			return ["%s<=%d" % [column, value1]]

		CompareMode.RANGE:
			var v1 = value1 if value1 != -1 else -999999
			var v2 = value2 if value2 != -1 else 999999
			return ["(%s BETWEEN %d AND %d)" % [column, v1, v2]]
			
		CompareMode.QUESTION_MARK:
			return ["%s=-2" % column]
			
		CompareMode.ANY:
			return []

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
		"all_datas.level & 255",
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

	var base_conditions = build_number_condition(
		"(all_datas.level >> 24) & 255",
		mode,
		value1,
		value2
	)

	if base_conditions.is_empty():
		return []

	var condition_str = base_conditions[0]

	return [
        "((all_datas.type & %d)=0 OR %s)"
		% [SearchMaps.TYPE_PENDULUM, condition_str]
	]


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
		"all_datas.atk",
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
		"all_datas.def",
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

	if include_arrows.is_empty() and exclude_arrows.is_empty():
		return conditions

	if !include_arrows.is_empty():

		var mask := 0
		for arrow in include_arrows:
			mask |= arrow

		conditions.append(
            "((all_datas.type & %d)=0 OR (all_datas.def & %d)=%d)"
			% [SearchMaps.TYPE_LINK, mask, mask]
		)

	if !exclude_arrows.is_empty():

		var mask := 0
		for arrow in exclude_arrows:
			mask |= arrow

		conditions.append(
            "((all_datas.type & %d)=0 OR (all_datas.def & %d)=0)"
			% [SearchMaps.TYPE_LINK, mask]
		)

	return conditions


#
# =====================================================
# OT
# =====================================================
#

static func build_ot_conditions(
	inc:Array[int],
	exc:Array[int]
) -> Array[String]:

	var conditions:Array[String] = []

	if !inc.is_empty():
		var mask := 0
		for v in inc: 
			mask |= v
		conditions.append("(all_datas.ot & %d)!=0" % mask)

	if !exc.is_empty():
		var mask := 0
		for v in exc: 
			mask |= v
		conditions.append("(all_datas.ot & %d)=0" % mask)

	return conditions


#
# =====================================================
# Banlist
# =====================================================
#

static func build_ban_conditions(
	inc:Array[int],
	exc:Array[int]
) -> Array[String]:

	var conditions:Array[String] = []

	if !inc.is_empty():
		conditions.append_array(_or_equals("all_datas.banlist", inc))

	if !exc.is_empty():
		var parts:Array[String] = []
		for v in exc:
			parts.append("all_datas.banlist != %d" % v)
		conditions.append("(" + " AND ".join(parts) + ")")

	return conditions


#
# =====================================================
# Card IDs
# =====================================================
#

static func build_special_card_conditions(
	ids:Array[int]
) -> Array[String]:

	return _or_equals(
		"all_datas.id",
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
SELECT all_datas.id
FROM all_datas
JOIN all_texts
ON all_datas.id=all_texts.id
"""

	if !conditions.is_empty():

		sql += "\nWHERE\n"
		sql += "\nAND\n".join(conditions)

	sql += "\nGROUP BY all_datas.id"
	sql += "\nORDER BY all_texts.name"

	return sql
