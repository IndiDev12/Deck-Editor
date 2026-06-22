class_name SearchMaps3
extends RefCounted


#
# =====================================================
# ATTRIBUTES
# =====================================================
#

const ATTRIBUTE_MAP := {
	"Earth": 1,
	"Water": 2,
	"Fire": 4,
	"Wind": 8,
	"Light": 16,
	"Dark": 32,
	"Divine": 64
}


#
# =====================================================
# MONSTER RACES
# =====================================================
#

const RACE_MAP := {
	"Warrior": 1,
	"Spellcaster": 2,
	"Fairy": 4,
	"Fiend": 8,
	"Zombie": 16,
	"Machine": 32,
	"Illusion": 33554432,
	"Aqua": 64,
	"Pyro": 128,
	"Rock": 256,
	"WingedBeast": 512,
	"Plant": 1024,
	"Insect": 2048,
	"Thunder": 4096,
	"Dragon": 8192,
	"Beast": 16384,
	"BeastWarrior": 32768,
	"Dinosaur": 65536,
	"Fish": 131072,
	"SeaSerpent": 262144,
	"Reptile": 524288,
	"Psychic": 1048576,
	"DivineBeast": 2097152,
	"DivinerBeast": 4194304,
	"Wyrm": 8388608,
	"Cyberse": 16777216
}


#
# =====================================================
# CARD TYPE FLAGS
# =====================================================
#

const TYPE_MONSTER := 0x1
const TYPE_SPELL := 0x2
const TYPE_TRAP := 0x4

const TYPE_NORMAL := 0x10
const TYPE_EFFECT := 0x20
const TYPE_FUSION := 0x40
const TYPE_RITUAL := 0x80
const TYPE_TRAP_MONSTER := 0x100
const TYPE_SPIRIT := 0x200
const TYPE_UNION := 0x400
const TYPE_GEMINI := 0x800
const TYPE_TUNER := 0x1000
const TYPE_SYNCHRO := 0x2000
const TYPE_TOKEN := 0x4000
const TYPE_QUICKPLAY := 0x10000
const TYPE_CONTINUOUS := 0x20000
const TYPE_EQUIP := 0x40000
const TYPE_FIELD := 0x80000
const TYPE_COUNTER := 0x100000
const TYPE_FLIP := 0x200000
const TYPE_TOON := 0x400000
const TYPE_XYZ := 0x800000
const TYPE_PENDULUM := 0x1000000
const TYPE_SPECIAL_SUMMON := 0x2000000
const TYPE_LINK := 0x4000000


#
# =====================================================
# MAIN CARD TYPES
# =====================================================
#

enum MainCardType {
	MONSTER,
	SPELL,
	TRAP,
	NONE
}


const MAIN_TYPE_MAP := {
	"Monster": TYPE_MONSTER,
	"Spell": TYPE_SPELL,
	"Trap": TYPE_TRAP,
	#"None" : NONE
}


#
# =====================================================
# MONSTER CATEGORIES
# =====================================================
#

# Regular = not Ritual/Fusion/Synchro/XYZ/Link
const MONSTER_CATEGORY_REGULAR := "Regular"
const MONSTER_CATEGORY_RITUAL := "Ritual"
const MONSTER_CATEGORY_FUSION := "Fusion"
const MONSTER_CATEGORY_SYNCHRO := "Synchro"
const MONSTER_CATEGORY_XYZ := "XYZ"
const MONSTER_CATEGORY_LINK := "Link"
const MONSTER_CATEGORY_TOKEN := "Token"


const EXTRA_MONSTER_FLAGS := [
	TYPE_RITUAL,
	TYPE_FUSION,
	TYPE_SYNCHRO,
	TYPE_XYZ,
	TYPE_LINK,
	TYPE_TOKEN
]



#
# =====================================================
# MONSTER CATEGORIES
# =====================================================
#

const MONSTER_CATEGORY_MAP := {
	"Ritual": TYPE_RITUAL,
	"Fusion": TYPE_FUSION,
	"Synchro": TYPE_SYNCHRO,
	"Xyz": TYPE_XYZ,
	"Link": TYPE_LINK,
	"Token": TYPE_TOKEN
}




#
# =====================================================
# MONSTER SUBTYPES
# =====================================================
#

const MONSTER_SUBTYPE_MAP := {
	"Normal": TYPE_NORMAL,
	"Effect": TYPE_EFFECT,
	"SpecialSummon": TYPE_SPECIAL_SUMMON,
	"Fusion": TYPE_FUSION,
	"Ritual": TYPE_RITUAL,
	"Spirit": TYPE_SPIRIT,
	"Union": TYPE_UNION,
	"Gemini": TYPE_GEMINI,
	"Tuner": TYPE_TUNER,
	"Synchro": TYPE_SYNCHRO,
	#"Token": TYPE_TOKEN,
	"Flip": TYPE_FLIP,
	"Toon": TYPE_TOON,
	"XYZ": TYPE_XYZ,
	"Pendulum": TYPE_PENDULUM,
	"Link": TYPE_LINK
}


#
# =====================================================
# SPELL SUBTYPES
# =====================================================
#

# Normal spell is special (no extra subtype bits)
const SPELL_SUBTYPE_MAP := {
	"QuickPlay": TYPE_QUICKPLAY,
	"Continuous": TYPE_CONTINUOUS,
	"Equip": TYPE_EQUIP,
	"Field": TYPE_FIELD,
	"Ritual": TYPE_RITUAL
}


#
# =====================================================
# TRAP SUBTYPES
# =====================================================
#

# Normal trap is special (no Counter or Continuous)
const TRAP_SUBTYPE_MAP := {
	"Continuous": TYPE_CONTINUOUS,
	"Counter": TYPE_COUNTER
}


#
# =====================================================
# LINK ARROWS
# =====================================================
#

const LINK_ARROW_BITS := {
	"BottomLeft": 1,
	"Bottom": 2,
	"BottomRight": 4,
	"Left": 8,
	"Right": 32,
	"TopLeft": 64,
	"Top": 128,
	"TopRight": 256
}


#
# =====================================================
# OT VALUES
# =====================================================
#

const OT_MAP := {
	"TCG": "TCG",
	"OCG": "OCG",
	"OCGTCG": "OCG/TCG",
	"AnimeManga": "Anime/Manga",
	"Rush": "Rush"
}


#
# =====================================================
# BANLIST
# =====================================================
#

const BAN_BANNED := 0
const BAN_LIMITED := 1
const BAN_SEMILIMITED := 2
const BAN_UNLIMITED := 3


#
# =====================================================
# CARD TYPE GROUPS
# =====================================================
#

const TYPE_EFFECT_GROUP := [
	TYPE_EFFECT
]

const TYPE_NORMAL_GROUP := [
	TYPE_NORMAL
]

const TYPE_FUSION_GROUP := [
	TYPE_FUSION
]

const TYPE_SYNCHRO_GROUP := [
	TYPE_SYNCHRO
]

const TYPE_XYZ_GROUP := [
	TYPE_XYZ
]

const TYPE_LINK_GROUP := [
	TYPE_LINK
]

const TYPE_RITUAL_GROUP := [
	TYPE_RITUAL
]


#
# =====================================================
# LINK ARROW ORDER
# =====================================================
#

const LINK_ARROW_ORDER := [
	"TopLeft",
	"Top",
	"TopRight",
	"Left",
	"Right",
	"BottomLeft",
	"Bottom",
	"BottomRight"
]


#
# =====================================================
# NUMBER MODES
# =====================================================
#

enum CompareMode {
	EQUAL,
	NOT_EQUAL,
	GREATER,
	GREATER_EQUAL,
	LESS,
	LESS_EQUAL,
	RANGE,
	ANY
}


#
# =====================================================
# SUBTYPE MATCH MODE
# =====================================================
#

enum SubtypeMatchMode {
	ANY,
	ALL
}
