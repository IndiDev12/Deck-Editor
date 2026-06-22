class_name ThumbnailLoader1
extends Node

signal thumbnail_loaded(id:int, texture:Texture2D)

const PICS_PATH := "/mnt/9A6CAFB86CAF8D97/Users/egycn/my_shared/my_projects/484x700"

const DEFAULT_TEXTURE := preload(
	"res://assets/themes/default/textures/card_covers/cover.jpg"
)

static var _cache: Dictionary[int, Texture2D] = {}


func get_texture(id:int) -> Texture2D:

	if _cache.has(id):
		return _cache[id]

	var path := "%s/%d.jpg" % [PICS_PATH, id]

	var texture := load_external_texture(path)

	_cache[id] = texture

	thumbnail_loaded.emit(id, texture)

	return texture


func load_external_texture(path:String) -> Texture2D:

	if !FileAccess.file_exists(path):
		return DEFAULT_TEXTURE

	var image := Image.new()

	var err := image.load(path)

	if err != OK:
		push_warning("Failed to load image: %s" % path)
		return DEFAULT_TEXTURE

	return ImageTexture.create_from_image(image)
