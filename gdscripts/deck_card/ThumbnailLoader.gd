class_name ThumbnailLoader
extends Node

signal thumbnail_loaded(id:int, texture:Texture2D)

const PICS_PATH := "/mnt/9A6CAFB86CAF8D97/Users/egycn/my_shared/my_projects/484x700"
const DEFAULT_TEXTURE := preload("res://assets/themes/default/textures/card_covers/cover.jpg")

const MAX_CACHE_SIZE := 250 # Keep memory strictly limited

var _cache: Dictionary[int, Texture2D] = {}
var _cache_order: Array[int] = [] # Tracks LRU (Least Recently Used)

var _load_queue: Array[int] = []
var _queue_mutex := Mutex.new()
var _thread := Thread.new()
var _thread_active := true
var _semaphore := Semaphore.new()

func _init() -> void:
	_thread.start(_thread_func)

func _exit_tree() -> void:
	_thread_active = false
	_semaphore.post()
	_thread.wait_to_finish()

func _thread_func() -> void:
	while _thread_active:
		_semaphore.wait()
		if !_thread_active: break
		
		_queue_mutex.lock()
		var id = -1
		if _load_queue.size() > 0:
			id = _load_queue.pop_front()
		_queue_mutex.unlock()
		
		if id != -1:
			_load_image(id)

func _load_image(id: int) -> void:
	if _cache.has(id): return
	
	var path := "%s/%d.jpg" % [PICS_PATH, id]
	var tex: Texture2D = DEFAULT_TEXTURE
	
	if FileAccess.file_exists(path):
		var image := Image.new()
		var err := image.load(path)
		if err == OK:
			# Generate mipmaps
			image.generate_mipmaps()
			tex = ImageTexture.create_from_image(image)
		else:
			push_warning("Failed to load image: %s" % path)
			
	call_deferred("_apply_loaded_texture", id, tex)

func _apply_loaded_texture(id: int, texture: Texture2D) -> void:
	if _cache.has(id):
		_cache_order.erase(id)
	_cache[id] = texture
	_cache_order.append(id)
	
	# Enforce memory limit by removing oldest textures
	while _cache_order.size() > MAX_CACHE_SIZE:
		var oldest_id = _cache_order.pop_front()
		_cache.erase(oldest_id)
		
	thumbnail_loaded.emit(id, texture)

func get_texture(id: int) -> Texture2D:
	if _cache.has(id):
		_cache_order.erase(id)
		_cache_order.append(id)
		return _cache[id]
		
	request_preload(id)
	return DEFAULT_TEXTURE

func request_preload(id: int) -> void:
	if _cache.has(id): return
	_queue_mutex.lock()
	if not _load_queue.has(id):
		_load_queue.append(id)
		_semaphore.post()
	_queue_mutex.unlock()

# CALLED BY VISUAL GRID ON SCROLL / JUMP
# Drops ALL pending loads outside the new 100-card range instantly!
func set_active_range(ids: Array[int]) -> void:
	_queue_mutex.lock()
	_load_queue.clear()
	
	# Add the new range to the queue. 
	# We iterate backwards so the first visible cards end up at the front of the queue.
	var i = ids.size() - 1
	while i >= 0:
		var id = ids[i]
		if !_cache.has(id) and not _load_queue.has(id):
			_load_queue.push_front(id)
			_semaphore.post()
		i -= 1
	_queue_mutex.unlock()
