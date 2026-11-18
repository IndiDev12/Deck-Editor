extends HFlowContainer
#extends VirtualCardGrid
const CARD_SCENE := preload("res://scenes/reusable_components/deck_card.tscn")
const CREATE_BATCH_SIZE := 10

@onready var search_box: PanelContainer = $"../../../Header/SearchBox"


var thread: Thread

# Contains UI-ready card dictionaries returned by CardDatabaseAdapter
var result_ids: Array[int] = []

var next_index := 0
var loading := false


func _ready() -> void:

	search_box.search_finished.connect(
		_on_search_finished
	)


func _exit_tree() -> void:

	if thread != null and thread.is_started():
		thread.wait_to_finish()


func _on_search_finished(ids:Array[int]) -> void:
	
	print("id s are:" , ids)
	#set_results(ids)
	result_ids = ids
	#clear_cards()
#
	#result_ids.clear()
#
	#next_index = 0
#
	#if thread != null and thread.is_started():
		#thread.wait_to_finish()
#
	#thread = Thread.new()
#
	#thread.start(
		#_thread_load_cards.bind(ids)
	#)


func clear_cards() -> void:

	for child in get_children():
		child.queue_free()



func _thread_load_cards(ids:Array[int]) -> void:

	var cards:Array[int] = []

	#
	# NOTE:
	# If CardDatabase uses SQLite and isn't thread-safe,
	# move this loop back to the main thread.
	#



	
	
	var rows = CardDatabase.get_cards(ids)
	for row in rows:

		cards.append(
			CardDatabaseAdapter.from_database(row)
		)

	call_deferred(
		"_cards_loaded",
		cards
	)


func _cards_loaded(cards:Array[int]) -> void:

	if thread != null:
		thread.wait_to_finish()

	result_ids = cards

	next_index = 0

	loading = true

	load_next_batch()


func load_next_batch() -> void:

	while next_index < result_ids.size():

		var end_index :int= min(
			next_index + CREATE_BATCH_SIZE,
			result_ids.size()
		)

		for i in range(next_index, end_index):

			var card = CARD_SCENE.instantiate()

			add_child(card)

			card.setup(result_ids[i])

		next_index = end_index

		await get_tree().process_frame

	loading = false
