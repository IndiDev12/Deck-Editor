extends Node

signal database_opened
signal database_closed

const MAIN_DB_PATH := "res://cdb/cards.cdb"
const RUSH_DB_PATH := "res://cdb/cards-rush.cdb"

var db : SQLite
var current_path := ""

var _card_cache : Dictionary[int, Dictionary] = {}

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
		database_opened.emit()
	else:
		push_error("Failed to open database: " + path)

	return success


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


func card_exists(card_id:int) -> bool:

	var row := query_single(
		"SELECT id FROM datas WHERE id=%d LIMIT 1" % card_id
	)

	return !row.is_empty()


func get_card(card_id:int) -> Dictionary:

	if _card_cache.has(card_id):
		return _card_cache[card_id]

	var row := query_single(
		"""
		SELECT *
		FROM datas
		JOIN texts
		ON datas.id=texts.id
		WHERE datas.id=%d
		LIMIT 1
		""" % card_id
	)

	_card_cache[card_id] = row

	return row


func get_card_name(card_id:int) -> String:

	var row := query_single(
		"SELECT name FROM texts WHERE id=%d" % card_id
	)

	if row.is_empty():
		return ""

	return row.name


func get_card_description(card_id:int) -> String:

	var row := query_single(
		"SELECT desc FROM texts WHERE id=%d" % card_id
	)

	if row.is_empty():
		return ""

	return row.desc


func get_all_card_ids() -> Array[int]:

	var rows := query(
		"SELECT id FROM datas ORDER BY id"
	)

	var ids : Array[int] = []

	for row in rows:
		ids.append(row.id)

	return ids


func execute(sql:String) -> bool:

	if db == null:
		return false

	return db.query(sql)
