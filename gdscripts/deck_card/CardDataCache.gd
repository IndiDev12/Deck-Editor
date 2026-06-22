class_name CardDataCache
extends RefCounted

static var cache := {}


static func get_data(id:int)->Dictionary:

	if cache.has(id):
		return cache[id]

	var row = CardDatabase.get_card(id)

	var data = CardDatabaseAdapter.from_database(row)

	cache[id] = data

	return data
