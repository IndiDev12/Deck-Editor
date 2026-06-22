## SearchMaps.gd
#class_name SearchMaps
#extends RefCounted
#
#
##
## ===== ATTRIBUTES =====
##
#
#const ATTRIBUTE_MAP := {
	#"Earth": 1,
	#"Water": 2,
	#"Fire": 4,
	#"Wind": 8,
	#"Light": 16,
	#"Dark": 32,
	#"Divin": 64
#}
#
#
##
## ===== MONSTER RACES =====
##
#
#const RACE_MAP := {
	#"Warrior": 1,
	#"Spellcaster": 2,
	#"Fairy": 4,
	#"Fiend": 8,
	#"Zombie": 16,
	#"Machine": 32,
	#"Illusion": 33554432,
	#"Aqua": 64,
	#"Pyro": 128,
	#"Rock": 256,
	#"WingedBeast": 512,
	#"Plant": 1024,
	#"Insect": 2048,
	#"Thunder": 4096,
	#"Dragon": 8192,
	#"Beast": 16384,
	#"BeastWarrior": 32768,
	#"Dinosaur": 65536,
	#"Fish": 131072,
	#"SeaSerpent": 262144,
	#"Reptile": 524288,
	#"Psychic": 1048576,
	#"DivinBeast": 2097152,
	#"DivinerBeast": 4194304,
	#"Wyrm": 8388608,
	#"Cyberse": 16777216
#}
#
#
##
## ===== MAIN TYPE GROUPS =====
##
#
#const TYPE_EFFECT := [
	#33554465,
	#33,
	#16777249,
	#33558561,
	#50331681,
	#2097185,
	#4129,
	#5153,
	#1057,
	#2081,
	#18874401,
	#545,
	#16781345,
	#37748769,
	#2101281,
	#33554977,
	#16777761
#]
#
#const TYPE_SYNCHRO := [
	#8225,
	#16785441,
	#12321,
	#8193
#]
#
#const TYPE_FUSION := [
	#97,
	#16777313,
	#4193,
	#65,
	#4161
#]
#
#const TYPE_XYZ := [
	#8388641,
	#25165857,
	#8388609
#]
#
#const TYPE_LINK := [
	#67108897,
	#67108865
#]
#
#const TYPE_NORMAL := [
	#17,
	#4113,
	#16777233,
	#16781329
#]
#
#const TYPE_TOKEN := [
	#16401,
	#20497
#]
#
#const TYPE_RITUAL := [
	#129,
	#161,
	#4257,
	#673,
	#16777377,
	#2097313
#]
#
#const TYPE_SPELL := [
	#524290,
	#262146,
	#131074,
	#65538,
	#130,
	#2
#]
#
#const TYPE_TRAP := [
	#1048580,
	#131076,
	#4
#]
#
#
##
## ===== SUBTYPE GROUPS =====
##
#
#const SUBTYPE_EFFECT := [
	#33,
	#2097185,
	#4129,
	#5153,
	#2081,
	#18874401,
	#545,
	#16781345,
	#37748769,
	#4194337,
	#2101281,
	#33554977,
	#16777761,
	#33554465,
	#33558561,
	#50331681,
	#16777249,
	#8225,
	#12321,
	#97,
	#4193,
	#8388641,
	#67108897,
	#161,
	#4257,
	#673,
	#16777377,
	#16785441,
	#16777313,
	#25165857
#]
#
#const SUBTYPE_SPECIAL_SUMMON := [
	#33554465,
	#33558561,
	#50331681,
	#37748769,
	#33554977
#]
#
#const SUBTYPE_PENDULUM := [
	#16777249,
	#50331681,
	#18874401,
	#16781345,
	#16777761,
	#16785441,
	#16777313,
	#25165857,
	#16777233,
	#16781329,
	#16777377
#]
#
#const SUBTYPE_TUNER := [
	#33558561,
	#4129,
	#5153,
	#16781345,
	#2101281,
	#12321,
	#4193,
	#4161,
	#4113,
	#16781329,
	#20497,
	#4257
#]
#
#const SUBTYPE_FLIP := [
	#2097185,
	#18874401,
	#2101281
#]
#
#const SUBTYPE_UNION := [
	#5153,
	#1057
#]
#
#const SUBTYPE_GEMINI := [
	#2081
#]
#
#const SUBTYPE_SPIRIT := [
	#545,
	#33554977,
	#16777761,
	#673
#]
#
#const SUBTYPE_TOON := [
	#37748769,
	#4194337
#]
#
#const SUBTYPE_NONE_EFFECT_NOR_NORMAL := [
	#8193,
	#65,
	#4161,
	#8388609,
	#67108865,
	#129
#]
#
#
##
## ===== LINK ARROWS =====
##
#
#const LINK_ARROW_MAP := {
	#"t": [
		#128,130,131,132,133,134,135,136,138,139,
		#160,161,162,163,166,168,170,173,175,196,
		#387,388,390,422,448,490,384
	#],
#
	#"tl": [
		#64,66,68,69,77,196,325,448,490
	#],
#
	#"l": [
		#8,9,10,12,14,40,41,42,43,45,46,47,
		#77,136,138,139,168,170,173,175,490
	#],
#
	#"bl": [
		#1,3,5,7,9,33,39,41,43,45,47,
		#69,77,131,133,135,139,161,163,
		#173,175,257,325,387,37
	#],
#
	#"b": [
		#2,3,6,7,10,14,34,38,39,42,43,46,47,
		#66,130,131,134,135,138,139,162,163,
		#166,170,175,387,390,422,490
	#],
#
	#"br": [
		#4,5,6,7,12,14,36,38,39,45,46,47,
		#68,69,77,132,133,134,135,166,
		#173,175,196,260,325,388,390,422,37
	#],
#
	#"r": [
		#32,33,34,36,38,39,40,41,42,43,45,46,47,
		#160,161,162,163,166,168,170,173,175,
		#422,490,37,288
	#],
#
	#"tr": [
		#256,257,260,325,387,388,390,422,448,490,288,384
	#]
#}
#
#
##
## ===== OT VALUES =====
##
#
#const OT_MAP := {
	#"TCG": "TCG",
	#"OCG": "OCG",
	#"AnimeManga": "Anime/Manga"
#}
#
#
##
## ===== BAN LIST VALUES =====
##
#
#const BAN_BANNED := 0
#const BAN_LIMITED := 1
#const BAN_SEMILIMITED := 2
#const BAN_UNLIMITED := 3
#
#
##
## ===== MAIN CARD TYPE OPTIONBUTTON =====
##
#
#enum MainCardType {
	#MONSTER,
	#SPELL,
	#TRAP,
	#NONE
#}
#
#
##
## ===== HELPER =====
##
#
#static func build_or_equals(column:String, values:Array) -> String:
	#if values.is_empty():
		#return ""
#
	#var parts:Array[String] = []
#
	#for value in values:
		#parts.append("%s=%s" % [column, str(value)])
#
	#return "(" + " OR ".join(parts) + ")"
#
#
#static func build_in(column:String, values:Array) -> String:
	#if values.is_empty():
		#return ""
#
	#var txt:Array[String] = []
#
	#for value in values:
		#txt.append(str(value))
#
	#return "%s IN (%s)" % [
		#column,
		#",".join(txt)
	#]
