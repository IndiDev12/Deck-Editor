class_name CardImageCache
extends RefCounted

static var cache: Dictionary = {}

static func get_texture(id:int) -> Texture2D:

	if cache.has(id):
		return cache[id]

	var path := "res://pics/%d.jpg" % id

	var texture := ResourceLoader.load(path)

	cache[id] = texture

	return texture
