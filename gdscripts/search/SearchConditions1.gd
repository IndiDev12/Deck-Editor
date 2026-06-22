## SearchConditions.gd
#
#class_name SearchConditions
#extends RefCounted
#
#
##
##=====================================================
## Helpers
##=====================================================
##
#
#static func _or_equals(column:String, values:Array) -> Array[String]:
	#if values.is_empty():
		#return []
#
	#var parts:Array[String] = []
#
	#for value in values:
		#parts.append("%s=%d" % [column, value])
#
	#return [
		#"(" + " OR ".join(parts) + ")"
	#]
#
#
#static func _between(column:String, min_value:int, max_value:int) -> Array[String]:
#
	#if min_value == 0 and max_value == 0:
		#return []
#
	#if min_value == 0:
		#min_value = -999999
#
	#if max_value == 0:
		#max_value = 999999
#
	#return [
		#"(%s BETWEEN %d AND %d)"
		#% [column, min_value, max_value]
	#]
#
#
##
##=====================================================
## Text
##=====================================================
##
#
#static func build_text_conditions(
	#keyword:String,
	#search_name:bool,
	#search_description:bool
#) -> Array[String]:
#
	#var conditions:Array[String] = []
#
	#keyword = keyword.strip_edges()
#
	#if keyword.is_empty():
		#return conditions
#
	#keyword = keyword.replace("'", "''")
#
	#var parts:Array[String] = []
#
	#if search_name:
		#parts.append(
			#"texts.name LIKE '%%%s%%'" % keyword
		#)
#
	#if search_description:
		#parts.append(
			#"texts.desc LIKE '%%%s%%'" % keyword
		#)
#
	#if !parts.is_empty():
		#conditions.append(
			#"(" + " OR ".join(parts) + ")"
		#)
#
	#return conditions
#
#
##
##=====================================================
## Attribute
##=====================================================
##
#
#static func build_attribute_conditions(
	#values:Array[int]
#) -> Array[String]:
#
	#var selected:Array[String] = []
#
	#for value in values:
		#selected.append(
			#"datas.attribute=%d" % value
		#)
#
	#if selected.is_empty():
		#return []
#
	#return [
		#"(" + " OR ".join(selected) + ")"
	#]
#
#
##
##=====================================================
## Race
##=====================================================
##
#
#static func build_race_conditions(
	#values:Array[int]
#) -> Array[String]:
#
	#var selected:Array[String] = []
#
	#for value in values:
		#selected.append(
			#"datas.race=%d" % value
		#)
#
	#if selected.is_empty():
			#return []
#
	#return [
		#"(" + " OR ".join(selected) + ")"
	#]
#
#
##
##=====================================================
## Card Types
##=====================================================
##
#
#static func build_card_type_conditions(
	#selected_types:Array[int]
#) -> Array[String]:
#
	#return _or_equals(
		#"datas.type",
		#selected_types
	#)
#
#
##
##=====================================================
## Main Categories
##=====================================================
##
#
#static func build_main_type_conditions(
	#effect:bool,
	#synchro:bool,
	#fusion:bool,
	#xyz:bool,
	#link:bool,
	#normal:bool,
	#token:bool,
	#ritual:bool,
	#spell:bool,
	#trap:bool
#) -> Array[String]:
#
	#var values:Array[int] = []
#
	#if effect:
		#values += SearchMaps.TYPE_EFFECT
#
	#if synchro:
		#values += SearchMaps.TYPE_SYNCHRO
#
	#if fusion:
		#values += SearchMaps.TYPE_FUSION
#
	#if xyz:
		#values += SearchMaps.TYPE_XYZ
#
	#if link:
		#values += SearchMaps.TYPE_LINK
#
	#if normal:
		#values += SearchMaps.TYPE_NORMAL
#
	#if token:
		#values += SearchMaps.TYPE_TOKEN
#
	#if ritual:
		#values += SearchMaps.TYPE_RITUAL
#
	#if spell:
		#values += SearchMaps.TYPE_SPELL
#
	#if trap:
		#values += SearchMaps.TYPE_TRAP
#
	#return build_card_type_conditions(values)
#
#
##
##=====================================================
## Subtypes
##=====================================================
##
#
#static func build_subtype_conditions(
	#effect_sub:bool,
	#special_summon:bool,
	#pendulum:bool,
	#tuner:bool,
	#flip:bool,
	#union_:bool,
	#gemini:bool,
	#spirit:bool,
	#toon:bool,
	#none_effect_normal:bool
#) -> Array[String]:
#
	#var values:Array[int] = []
#
	#if effect_sub:
		#values += SearchMaps.SUBTYPE_EFFECT
#
	#if special_summon:
		#values += SearchMaps.SUBTYPE_SPECIAL_SUMMON
#
	#if pendulum:
		#values += SearchMaps.SUBTYPE_PENDULUM
#
	#if tuner:
		#values += SearchMaps.SUBTYPE_TUNER
#
	#if flip:
		#values += SearchMaps.SUBTYPE_FLIP
#
	#if union_:
		#values += SearchMaps.SUBTYPE_UNION
#
	#if gemini:
		#values += SearchMaps.SUBTYPE_GEMINI
#
	#if spirit:
		#values += SearchMaps.SUBTYPE_SPIRIT
#
	#if toon:
		#values += SearchMaps.SUBTYPE_TOON
#
	#if none_effect_normal:
		#values += SearchMaps.SUBTYPE_NONE_EFFECT_NOR_NORMAL
#
	#return build_card_type_conditions(values)
#
#
##
##=====================================================
## Level
##=====================================================
##
#
#static func build_level_conditions(
	#min_level:int,
	#max_level:int
#) -> Array[String]:
#
	#return _between(
		#"datas.level",
		#min_level,
		#max_level
	#)
#
#
##
##=====================================================
## Attack
##=====================================================
##
#
#static func build_atk_conditions(
	#min_atk:int,
	#max_atk:int
#) -> Array[String]:
#
	#return _between(
		#"datas.atk",
		#min_atk,
		#max_atk
	#)
#
#
##
##=====================================================
## Defense
##=====================================================
##
#
#static func build_def_conditions(
	#min_def:int,
	#max_def:int
#) -> Array[String]:
#
	#return _between(
		#"datas.def",
		#min_def,
		#max_def
	#)
#
#
##
##=====================================================
## Link Arrows
##=====================================================
##
#
#static func build_link_arrow_conditions(
	#selected_defs:Array[int]
#) -> Array[String]:
#
	#return _or_equals(
		#"datas.def",
		#selected_defs
	#)
#
#
##
##=====================================================
## OT
##=====================================================
##
#
#static func build_ot_conditions(
	#selected_ots:Array[String]
#) -> Array[String]:
#
	#if selected_ots.is_empty():
		#return []
#
	#var parts:Array[String] = []
#
	#for value in selected_ots:
		#parts.append(
			#"datas.ot='%s'" % value
		#)
#
	#return [
		#"(" + " OR ".join(parts) + ")"
	#]
#
#
##
##=====================================================
## Banlist
##=====================================================
##
#
#static func build_ban_conditions(
	#selected_values:Array[int]
#) -> Array[String]:
#
	#return _or_equals(
		#"datas.banlist",
		#selected_values
	#)
#
#
##
##=====================================================
## Special Egyptian Gods
##=====================================================
##
#
#static func build_special_card_conditions(
	#selected_ids:Array[int]
#) -> Array[String]:
#
	#return _or_equals(
		#"datas.id",
		#selected_ids
	#)
#
#
##
##=====================================================
## Combine All Conditions
##=====================================================
##
#
#static func assemble_query(
	#conditions:Array[String]
#) -> String:
#
	#var sql := """
#SELECT datas.id
#FROM datas
#JOIN texts
#ON datas.id=texts.id
#"""
#
	#if !conditions.is_empty():
#
		#sql += "\nWHERE\n"
		#sql += "\nAND\n".join(conditions)
#
	#sql += "\nORDER BY texts.name"
#
	#return sql
