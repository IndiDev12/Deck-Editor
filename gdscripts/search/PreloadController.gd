# PreloadController.gd
extends Node

## Preloads common/frequently used card thumbnails on game start
func _ready() -> void:
	# Run in background
	var thread := Thread.new()
	thread.start(_preload_worker)
	# Don't wait - let it run in background


func _preload_worker() -> void:
	# Get all card IDs
	var all_ids := CardDatabase.get_all_card_ids()
	
	# Preload in batches to not overwhelm
	var batch_size := 100
	for i in range(0, all_ids.size(), batch_size):
		var batch := all_ids.slice(i, i + batch_size)
		AsyncThumbnailLoader.preload_many(batch)
		
		# Small yield to let other threads work
		OS.delay_msec(1)
	
	print("Preload complete: %d textures" % AsyncThumbnailLoader.cache_size())
