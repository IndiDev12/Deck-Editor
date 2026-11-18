# AsyncThumbnailLoader.gd
class_name AsyncThumbnailLoader
extends Node

signal thumbnail_loaded(id: int, texture: Texture2D)
signal all_loaded

const PICS_PATH := "/mnt/9A6CAFB86CAF8D97/Users/egycn/my_shared/my_projects/484x700"
const DEFAULT_TEXTURE := preload("res://assets/themes/default/textures/card_covers/cover.jpg")

# Static cache shared across all instances
static var _cache: Dictionary[int, Texture2D] = {}
static var _pending: Dictionary[int, bool] = {}
static var _instance: AsyncThumbnailLoader = null

# Thread management
var _threads: Array[Thread] = []
var _max_threads: int = 4
var _mutex: Mutex
var _semaphore: Semaphore
var _should_exit: bool = false
var _work_queue: Array[int] = []
var _results: Array[Dictionary] = []  # {id, image} - processed on main thread
var _pending_count: int = 0
var _total_requested: int = 0


func _init() -> void:
	_instance = self
	_mutex = Mutex.new()
	_semaphore = Semaphore.new()


func _ready() -> void:
	# Start worker threads
	for i in _max_threads:
		var thread := Thread.new()
		thread.start(_worker_loop)
		_threads.append(thread)


func _exit_tree() -> void:
	_should_exit = true
	
	# Wake all threads so they can exit
	for i in _max_threads:
		_semaphore.post()
	
	# Wait for completion
	for thread in _threads:
		thread.wait_to_finish()
	
	_threads.clear()
	_instance = null


func _process(_delta: float) -> void:
	# Process completed image loads on MAIN THREAD (required for Texture2D)
	_mutex.lock()
	var local_results := _results.duplicate()
	_results.clear()
	_mutex.unlock()
	
	for result in local_results:
		var id: int = result["id"]
		var image: Image = result["image"]
		var texture: Texture2D
		
		if image != null:
			texture = ImageTexture.create_from_image(image)
		else:
			texture = DEFAULT_TEXTURE
		
		_cache[id] = texture
		_pending.erase(id)
		_pending_count -= 1
		
		thumbnail_loaded.emit(id, texture)
	
	# Check if all done
	if _total_requested > 0 and _pending_count <= 0 and local_results.size() > 0:
		_total_requested = 0
		all_loaded.emit()


func _worker_loop() -> void:
	while true:
		_semaphore.wait()
		
		if _should_exit:
			return
		
		var id: int = -1
		
		_mutex.lock()
		if _work_queue.size() > 0:
			id = _work_queue.pop_front()
		_mutex.unlock()
		
		if id < 0:
			continue
		
		# Skip if already cached
		if _cache.has(id):
			_mutex.lock()
			_pending.erase(id)
			_pending_count -= 1
			_mutex.unlock()
			continue
		
		# Load image in background thread (Image loading is thread-safe)
		var path := "%s/%d.jpg" % [PICS_PATH, id]
		var image: Image = _load_image_safe(path)
		
		# Queue result for main thread processing
		_mutex.lock()
		_results.append({"id": id, "image": image})
		_mutex.unlock()


func _load_image_safe(path: String) -> Image:
	if !FileAccess.file_exists(path):
		return null
	
	var image := Image.new()
	var err := image.load(path)
	
	if err != OK:
		return null
	
	return image


# ============================================================
# PUBLIC API
# ============================================================

## Get texture - returns cached or default, queues async load if needed
static func get_texture(id: int) -> Texture2D:
	if _cache.has(id):
		return _cache[id]
	
	# Queue for async loading
	if !_pending.has(id) and _instance != null:
		_pending[id] = true
		_instance._enqueue(id)
	
	return DEFAULT_TEXTURE


## Check if texture is already loaded
static func is_loaded(id: int) -> bool:
	return _cache.has(id)


## Preload multiple textures
static func preload_many(ids: Array[int]) -> void:
	if _instance == null:
		return
	
	var to_queue: Array[int] = []
	
	for id in ids:
		if !_cache.has(id) and !_pending.has(id):
			_pending[id] = true
			to_queue.append(id)
	
	if to_queue.size() > 0:
		_instance._enqueue_batch(to_queue)


## Clear cache (call when switching databases, etc.)
static func clear_cache() -> void:
	_cache.clear()
	_pending.clear()


## Get cache size for debugging
static func cache_size() -> int:
	return _cache.size()


## Get pending count
static func pending_count() -> int:
	return _pending.size()


# ============================================================
# INTERNAL
# ============================================================

func _enqueue(id: int) -> void:
	_pending_count += 1
	_mutex.lock()
	_work_queue.append(id)
	_mutex.unlock()
	_semaphore.post()


func _enqueue_batch(ids: Array[int]) -> void:
	_pending_count += ids.size()
	_total_requested += ids.size()
	_mutex.lock()
	_work_queue.append_array(ids)
	_mutex.unlock()
	
	# Wake threads
	for i in mini(ids.size(), _max_threads):
		_semaphore.post()
