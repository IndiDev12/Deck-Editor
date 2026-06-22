extends Node

signal database_opened
signal database_closed

const MAIN_DB_PATH := "res://cdb/cards.cdb"
const RUSH_DB_PATH := "res://cdb/cards-rush.cdb"

var db: SQLite
var current_path := ""

var _card_cache: Dictionary[int, Dictionary] = {}
var _name_cache: Dictionary[int, String] = {}
var _desc_cache: Dictionary[int, String] = {}


func _ready() -> void:
	open_database()


func open_database(path:String = MAIN_DB_PATH) -> bool:

	if db != null:
		close_database()

	db = SQLite.new()
	db.path = path

	var success := db.open_db()

	if success:
		current_path = path

		_card_cache.clear()
		_name_cache.clear()
		_desc_cache.clear()
		
		# Attach rush database and create unified TEMP views
		_attach_rush_database()
		_setup_combined_views()
		
		# PRELOAD ALL CARDS INTO MEMORY (from both databases via views)
		print("Preloading card database into memory...")
		_preload_all_cards() 
		
		database_opened.emit()

	else:
		push_error("Failed to open database: " + path)

	return success


func _attach_rush_database() -> void:
	# Convert res:// path to absolute OS path for SQLite ATTACH
	var rush_abs_path := ProjectSettings.globalize_path(RUSH_DB_PATH)
	if FileAccess.file_exists(rush_abs_path):
		var attach_query := "ATTACH DATABASE '%s' AS rush;" % rush_abs_path
		var result := db.query(attach_query)
		if !result:
			push_error("Failed to attach rush database: " + rush_abs_path)
	else:
		push_warning("Rush database not found at: " + rush_abs_path)


func _setup_combined_views() -> void:
	# Check if rush database attached successfully and has tables
	db.query("SELECT name FROM rush.sqlite_master WHERE type='table' AND name='datas';")
	var rush_has_data = db.query_result.size() > 0
	
	# Drop views if they exist (safe to call)
	db.query("DROP VIEW IF EXISTS all_datas;")
	db.query("DROP VIEW IF EXISTS all_texts;")
	
	if rush_has_data:
		print("Rush database found. Creating unified views.")
		# TEMP VIEW is required to reference attached databases in SQLite!
		db.query("CREATE TEMP VIEW all_datas AS SELECT * FROM main.datas UNION ALL SELECT * FROM rush.datas;")
		db.query("CREATE TEMP VIEW all_texts AS SELECT * FROM main.texts UNION ALL SELECT * FROM rush.texts;")
	else:
		print("Rush database not found or empty. Using main database views.")
		db.query("CREATE TEMP VIEW all_datas AS SELECT * FROM main.datas;")
		db.query("CREATE TEMP VIEW all_texts AS SELECT * FROM main.texts;")


func _preload_all_cards() -> void:
	# Query the unified views instead of the base tables
	var rows := query("""
        SELECT * 
        FROM all_datas 
        JOIN all_texts ON all_datas.id = all_texts.id
	""")
	
	for row in rows:
		var card_id = int(row["id"])
		_card_cache[card_id] = row
		_name_cache[card_id] = row.get("name", "")
		_desc_cache[card_id] = row.get("desc", "")
		
	print("Preloaded ", _card_cache.size(), " cards.")


func close_database() -> void:

	if db == null:
		return

	db.close_db()
	db = null
	current_path = ""

	database_closed.emit()


func switch_to_main_database() -> void:
	if current_path != MAIN_DB_PATH:
		open_database(MAIN_DB_PATH)


func switch_to_rush_database() -> void:
	if current_path != RUSH_DB_PATH:
		open_database(RUSH_DB_PATH)


func query(sql:String) -> Array:

	if db == null:
		push_error("Database not opened")
		return []

	var success := db.query(sql)

	if !success:
		push_error("SQL error:\n" + sql)
		return []

	return db.query_result


func query_single(sql:String) -> Dictionary:

	var rows := query(sql)

	if rows.is_empty():
		return {}

	return rows[0]


func execute(sql:String) -> bool:

	if db == null:
		return false

	return db.query(sql)


func card_exists(card_id:int) -> bool:

	var row := query_single(
		"SELECT id FROM all_datas WHERE id=%d LIMIT 1" % card_id
	)

	return !row.is_empty()


#
# CARD CACHE
#


func get_cards_batch(ids: Array[int]) -> Array[Dictionary]:
	var cards: Array[Dictionary] = []
	for id in ids:
		var card := get_card(id)
		if !card.is_empty():
			cards.append(card)
	return cards


func get_card(card_id:int) -> Dictionary:
	if _card_cache.has(card_id):
		return _card_cache[card_id]
	return {}


func get_card_data(card_id:int) -> Dictionary:
	return get_card(card_id)


func get_cards(ids:Array[int]) -> Array[Dictionary]:

	var cards:Array[Dictionary] = []

	for id in ids:
		cards.append(
			get_card(id)
		)

	return cards


#
# NAME CACHE
#

func get_card_name(card_id:int) -> String:

	if _name_cache.has(card_id):
		return _name_cache[card_id]

	var row := query_single(
		"SELECT name FROM all_texts WHERE id=%d" % card_id
	)

	var name := ""

	if !row.is_empty():
		name = row.name

	_name_cache[card_id] = name

	return name


#
# DESCRIPTION CACHE
#

func get_card_description(card_id:int) -> String:

	if _desc_cache.has(card_id):
		return _desc_cache[card_id]

	var row := query_single(
		"SELECT desc FROM all_texts WHERE id=%d" % card_id
	)

	var desc := ""

	if !row.is_empty():
		desc = row.desc

	_desc_cache[card_id] = desc

	return desc


func get_all_card_ids() -> Array[int]:

	var rows := query(
        "SELECT id FROM all_datas ORDER BY id"
	)

	var ids:Array[int] = []

	for row in rows:
		ids.append(row.id)

	return ids
