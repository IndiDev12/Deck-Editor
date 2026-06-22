extends PanelContainer

const BASE_ASSET_PATH := "res://assets/themes/default/textures/"

# Special Egyptian Divine Beast Card IDs
const SLIFER_ID := 10000020
const OBELISK_ID := 10000000
const RA_ID := 10000010

# --- Link Arrow Lookup Arrays (from def value) ---
const TL_ARROW := [64,66,68,69,77,196,325,448,490]
const T_ARROW := [128,130,131,132,133,134,135,136,138,139,160,161,162,163,166,168,170,173,175,196,387,388,390,422,448,490,384]
const TR_ARROW := [256,257,260,325,387,388,390,422,448,490,288,384]
const L_ARROW := [8,9,10,12,14,40,41,42,43,45,46,47,77,136,138,139,168,170,173,175,490]
const R_ARROW := [32,33,34,36,38,39,40,41,42,43,45,46,47,160,161,162,163,166,168,170,173,175,422,490,37,288]
const BL_ARROW := [1,3,5,7,9,33,39,41,43,45,47,69,77,131,133,135,139,161,163,173,175,257,325,387,37]
const B_ARROW := [2,3,6,7,10,14,34,38,39,42,43,46,47,66,130,131,134,135,138,139,162,163,166,170,175,387,390,422,490]
const BR_ARROW := [4,5,6,7,12,14,36,38,39,45,46,47,68,69,77,132,133,134,135,166,173,175,196,260,325,388,390,422,37]

var current_card_id := -1

# --- Node References ---
@onready var card_preview_texture = $PreviewContainer/HBoxContainer/CardPreviewTexture
@onready var badges_bar = $PreviewContainer/HBoxContainer/ScrollContainer/CardProperiesBadgesBar

@onready var pendulum_preview = badges_bar.get_node("PendulumScalePreview")
@onready var links_preview = badges_bar.get_node("LinksPreview")
@onready var level_rank_preview = badges_bar.get_node("LevelRankPreview")
@onready var monster_type_preview = badges_bar.get_node("MonsterTypePreview")
@onready var spell_trap_type_preview = badges_bar.get_node("SpellTrapTypePreview")

@onready var header_panel = $PreviewContainer/CardInfo/HeaderPanel
@onready var card_name_label = $PreviewContainer/CardInfo/HeaderPanel/CardProperties/CardName
@onready var monster_atk_def = $PreviewContainer/CardInfo/HeaderPanel/CardProperties/MonsterAtkDef
@onready var atk_count = $PreviewContainer/CardInfo/HeaderPanel/CardProperties/MonsterAtkDef/HFlowContainer/Atk/Count
@onready var def_count = $PreviewContainer/CardInfo/HeaderPanel/CardProperties/MonsterAtkDef/HFlowContainer/Def/Count
@onready var card_desc_label = $PreviewContainer/CardInfo/CardDescription/ScrollContainer/RichTextLabel

func _ready() -> void:
	card_name_label.bbcode_enabled = true
	card_desc_label.bbcode_enabled = true

func update_preview(card_data: Dictionary) -> void:
	var new_id = card_data.get("id", 0)
	if new_id == current_card_id:
		return
		
	current_card_id = new_id
	_apply_card_data(card_data)

func _apply_card_data(data: Dictionary) -> void:
	var ctype: int = data.get("type", 0)
	var attribute: int = data.get("attribute", 0)
	var race: int = data.get("race", 0)
	var raw_level: int = data.get("level", 0)
	
	# Fix for ATK/DEF: Check both "attack"/"atk" and "defense"/"def" keys
	var attack: int = data.get("atk", data.get("attack", 0))
	var defense: int = data.get("def", data.get("defense", 0))
	
	# Unpack level and pendulum scale
	var actual_level := raw_level & 0xFF
	var lscale := (raw_level >> 16) & 0xFF
	
	var is_spell = ctype & SearchMaps.TYPE_SPELL
	var is_trap = ctype & SearchMaps.TYPE_TRAP
	var is_monster = not (is_spell or is_trap)
	var is_link = ctype & SearchMaps.TYPE_LINK
	var is_xyz = ctype & SearchMaps.TYPE_XYZ
	var is_pendulum = ctype & SearchMaps.TYPE_PENDULUM
	
	# 1. Update Texture and Play Animation
	var card_texture = CardThumbnailLoader.get_texture(current_card_id)
	card_preview_texture.play_flip_animation(card_texture)
	
	# 2. Update Badges Visibility & Textures
	_update_badges(ctype, attribute, race, actual_level, defense, lscale)
	
	# 3. Update Header Color
	_update_header_color(ctype, current_card_id)
	
	# 4. Update Name & Description
	_update_texts(data, current_card_id)
	
	# 5. Update ATK / DEF
	monster_atk_def.visible = is_monster
	if is_monster:
		atk_count.text = "?" if attack < 0 else str(attack)
		
		var def_node = monster_atk_def.get_node("HFlowContainer/Def")
		def_node.visible = not is_link
		if not is_link:
			def_count.text = "?" if defense < 0 else str(defense)

func _update_badges(ctype: int, attribute: int, race: int, level: int, def_val: int, lscale: int) -> void:
	var is_spell = ctype & SearchMaps.TYPE_SPELL
	var is_trap = ctype & SearchMaps.TYPE_TRAP
	var is_monster = not (is_spell or is_trap)
	var is_link = ctype & SearchMaps.TYPE_LINK
	var is_xyz = ctype & SearchMaps.TYPE_XYZ
	var is_pendulum = ctype & SearchMaps.TYPE_PENDULUM
	
	# Level/Rank (Link monsters don't show standard level/rank badge)
	level_rank_preview.visible = is_monster and not is_link
	if level_rank_preview.visible:
		var tex_path = BASE_ASSET_PATH + "level_rank_pendulum_links/rank.png" if is_xyz else BASE_ASSET_PATH + "level_rank_pendulum_links/level.png"
		level_rank_preview.get_node("VBoxContainer/LevelRankTexture").texture = load(tex_path)
		level_rank_preview.get_node("VBoxContainer/Count").text = str(level)
	
	# Pendulum
	pendulum_preview.visible = is_pendulum
	if pendulum_preview.visible:
		pendulum_preview.get_node("VBoxContainer/PendulumScaleTexture").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/pendulum_scale.png")
		pendulum_preview.get_node("VBoxContainer/Count").text = str(lscale)
	
	# Link Arrows
	links_preview.visible = is_link
	if links_preview.visible:
		var link_count = _update_link_arrows(def_val)
		# Update the Count node right in the middle of the link grid
		links_preview.get_node("GridContainer/Count").text = str(link_count)
		
	# Monster Type (Race & Attribute)
	monster_type_preview.visible = is_monster
	if monster_type_preview.visible:
		monster_type_preview.get_node("VBoxContainer/MonsterAttribute").texture = _get_attribute_texture(attribute)
		monster_type_preview.get_node("VBoxContainer/MonsterRace").texture = _get_race_texture(race)
		
	# Spell/Trap Type
	spell_trap_type_preview.visible = is_spell or is_trap
	if spell_trap_type_preview.visible:
		var st_attr_path = BASE_ASSET_PATH + "attributes/spell.png" if is_spell else BASE_ASSET_PATH + "attributes/trap.png"
		spell_trap_type_preview.get_node("VBoxContainer/SpellTrapAttribute").texture = load(st_attr_path)
		var st_type_tex = _get_spell_trap_type_texture(ctype)
		spell_trap_type_preview.get_node("VBoxContainer/SpellTrapType").texture = st_type_tex

# Uses the exact lookup lists provided to determine active arrows and count
func _update_link_arrows(def_value: int) -> int:
	var grid = links_preview.get_node("GridContainer")
	var count := 0
	
	if T_ARROW.has(def_value):
		grid.get_node("t").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/t_active.png")
		count += 1
	else:
		grid.get_node("t").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/t.png")
		
	if TL_ARROW.has(def_value):
		grid.get_node("tl").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/tl_active.png")
		count += 1
	else:
		grid.get_node("tl").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/tl.png")
		
	if TR_ARROW.has(def_value):
		grid.get_node("tr").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/tr_active.png")
		count += 1
	else:
		grid.get_node("tr").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/tr.png")
		
	if L_ARROW.has(def_value):
		grid.get_node("l").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/l_active.png")
		count += 1
	else:
		grid.get_node("l").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/l.png")
		
	if R_ARROW.has(def_value):
		grid.get_node("r").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/r_active.png")
		count += 1
	else:
		grid.get_node("r").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/r.png")
		
	if BL_ARROW.has(def_value):
		grid.get_node("bl").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/bl_active.png")
		count += 1
	else:
		grid.get_node("bl").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/bl.png")
		
	if B_ARROW.has(def_value):
		grid.get_node("b").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/b_active.png")
		count += 1
	else:
		grid.get_node("b").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/b.png")
		
	if BR_ARROW.has(def_value):
		grid.get_node("br").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/br_active.png")
		count += 1
	else:
		grid.get_node("br").texture = load(BASE_ASSET_PATH + "level_rank_pendulum_links/br.png")
		
	return count

func _update_header_color(ctype: int, card_id: int) -> void:
	var color = Color.WHITE
	
	match card_id:
		OBELISK_ID: color = Color("3352b2ff")
		SLIFER_ID: color = Color("b61100ff")
		RA_ID: color = Color("fada00ff")
		_:
			if ctype & SearchMaps.TYPE_LINK: color = Color("22497dff")
			elif ctype & SearchMaps.TYPE_XYZ: color = Color("0c071bff")
			elif ctype & SearchMaps.TYPE_SYNCHRO: color = Color("c5c5c5ff")
			elif ctype & SearchMaps.TYPE_FUSION: color = Color("693374ff")
			elif ctype & SearchMaps.TYPE_RITUAL: color = Color("3f70bbff")
			elif ctype & SearchMaps.TYPE_SPELL: color = Color("389563ff")
			elif ctype & SearchMaps.TYPE_TRAP: color = Color("a22f52ff")
			elif ctype & SearchMaps.TYPE_TOKEN: color = Color("716d61ff")
			elif ctype & SearchMaps.TYPE_NORMAL: color = Color("e4be44ff")
			elif ctype & SearchMaps.TYPE_EFFECT: color = Color("c06932ff")

	
	header_panel.self_modulate = color

func _update_texts(data: Dictionary, card_id: int) -> void:
	var card_name = data.get("name", "Unknown")
	var card_desc = data.get("desc", "")
	
	match card_id:
		OBELISK_ID:
			#card_name_label.add_theme_color_override("font_color", Color("0062c4ff"))
			#card_name_label.add_theme_color_override("font_outline_color", Color("00005bff"))
			card_name_label.text = "[shake rate=20.0 level=5 connected=1][b][color=0062c4ff][outline_color=00005bff][outline_size=10]" + card_name
		SLIFER_ID:
			#card_name_label.add_theme_color_override("font_color", Color("ff834eff"))
			#card_name_label.add_theme_color_override("font_outline_color", Color("fb0000ff"))
			card_name_label.text = "[wave amp=50 freq=5][color=FFA07A][outline_color=ff0402ff][outline_size=10][b]" + card_name + "[/b]" # [fade start=4 length=14] [tornado radius=10.0 freq=1.0 connected=1]
		RA_ID:
			#card_name_label.add_theme_color_override("font_color", Color("4e2e00ff"))
			#card_name_label.add_theme_color_override("font_outline_color", Color("ff9b32ff"))
			card_name_label.text = "[pulse freq=1.0 color=#d5480055 ease=-2.0][color=4e2e00ff][outline_color=ff9b32ff][outline_size=15][b]" + card_name + "[/b]" # [rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0]
		_:
			card_name_label.remove_theme_color_override("font_color")
			card_name_label.remove_theme_color_override("font_outline_color")
			card_name_label.text = "[b]" + card_name + "[/b]"
			
	card_desc_label.text = card_desc

# --- Helper Functions for Textures ---
func _get_attribute_texture(attr: int) -> Texture2D:
	var attr_name = SearchMaps.ATTRIBUTE_MAP.find_key(attr)
	if attr_name == null: return null
	return load(BASE_ASSET_PATH + "attributes/" + attr_name.to_lower() + ".png")

func _get_race_texture(race: int) -> Texture2D:
	var race_name = SearchMaps.RACE_MAP.find_key(race)
	if race_name == null: return null
	var file_name = race_name.to_lower()
	match file_name:
		"wingedbeast": file_name = "winged-beast"
		"divinebeast": file_name = "divine-beast"
		"divinerbeast": file_name = "diviner-beast"
		"seaserpent" : file_name = "sea-serpent"
		"beastwarrior" : file_name = "beast-warrior"
		"highdragon" : file_name = "high-dragon"
		"magicalknight" : file_name = "magical-knight"
		"omegapsychic" : file_name = "omega-psychic"
		"celestialwarrior" : file_name = "celestial-warrior"
	return load(BASE_ASSET_PATH + "monster_types/" + file_name + ".png")

func _get_spell_trap_type_texture(ctype: int) -> Texture2D:
	if ctype & SearchMaps.TYPE_CONTINUOUS: return load(BASE_ASSET_PATH + "spell_trap_types/continuous.png")
	if ctype & SearchMaps.TYPE_EQUIP: return load(BASE_ASSET_PATH + "spell_trap_types/equip.png")
	if ctype & SearchMaps.TYPE_FIELD: return load(BASE_ASSET_PATH + "spell_trap_types/field.png")
	if ctype & SearchMaps.TYPE_QUICKPLAY: return load(BASE_ASSET_PATH + "spell_trap_types/quick-play.png")
	if ctype & SearchMaps.TYPE_RITUAL: return load(BASE_ASSET_PATH + "spell_trap_types/ritual.png")
	if ctype & SearchMaps.TYPE_COUNTER: return load(BASE_ASSET_PATH + "spell_trap_types/counter.png")
	return null

func _on_deck_card_card_hovered(card_data: Dictionary) -> void:
	update_preview(card_data)
