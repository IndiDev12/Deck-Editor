class_name SearchQueryExecutor
extends RefCounted


#
# =====================================================
# CACHE
# =====================================================
#

var _search_cache: Dictionary = {}


#
# =====================================================
# QUERY
# =====================================================
#

func execute(
	sql: String
) -> Array[int]:

	if sql.is_empty():
		return []

	var rows

	if _search_cache.has(sql):

		rows = _search_cache[sql]

	else:

		rows = CardDatabase.query(sql)

		_search_cache[sql] = rows

	return _rows_to_ids(rows)


#
# =====================================================
# ROWS -> IDS
# =====================================================
#

func _rows_to_ids(
	rows
) -> Array[int]:

	var ids: Array[int] = []

	if rows == null:
		return ids

	for row in rows:

		if row is Dictionary:

			if row.has("id"):

				ids.append(
					int(row["id"])
				)

		else:

			# support objects with .id property
			ids.append(
				int(row.id)
			)

	return ids


#
# =====================================================
# EXISTS IN CACHE
# =====================================================
#

func has_cached(
	sql: String
) -> bool:

	return _search_cache.has(sql)


#
# =====================================================
# GET CACHED IDS
# =====================================================
#

func get_cached_ids(
	sql: String
) -> Array[int]:

	if !_search_cache.has(sql):
		return []

	return _rows_to_ids(
		_search_cache[sql]
	)


#
# =====================================================
# CACHE MANAGEMENT
# =====================================================
#

func clear_cache() -> void:

	_search_cache.clear()


func remove_cached_query(
	sql: String
) -> void:

	_search_cache.erase(sql)


func cache_size() -> int:

	return _search_cache.size()


#
# =====================================================
# PRELOAD QUERY
# =====================================================
#

func preload_query(
	sql: String
) -> void:

	if sql.is_empty():
		return

	if _search_cache.has(sql):
		return

	_search_cache[sql] = CardDatabase.query(sql)


#
# =====================================================
# DEBUG
# =====================================================
#

func print_cache() -> void:

	print("Cached searches:", _search_cache.size())

	for sql in _search_cache.keys():

		print("-------------------")
		print(sql)
