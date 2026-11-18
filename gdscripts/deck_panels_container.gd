extends Container

@onready var header: Control = $"../Header"

@onready var main_grid: SpreadFlowContainer = $MainDeckCardsGrid/ScrollContainer/DeckGridTest
@onready var extra_grid: SpreadFlowContainer = $ExtraCardsGrid/ScrollContainer/DeckGridTest
@onready var side_grid: SpreadFlowContainer = $SideDeckCardsGrid/ScrollContainer/DeckGridTest

func _ready() -> void:
	if header:
		header.deck_loaded.connect(_on_deck_loaded)
		
	# Connect clear button if you have it in DeckTools
	var clear_btn = header.get_node_or_null("HBoxContainer/DeckTools/Clear")
	if clear_btn and not clear_btn.pressed.is_connected(_on_clear):
		clear_btn.pressed.connect(_on_clear)

func _on_deck_loaded(deck_data: Dictionary) -> void:
	_populate_grid(main_grid, deck_data.get("main", []))
	_populate_grid(extra_grid, deck_data.get("extra", []))
	_populate_grid(side_grid, deck_data.get("side", []))

func _on_clear() -> void:
	_clear_grid(main_grid)
	_clear_grid(extra_grid)
	_clear_grid(side_grid)
	
	if header and header.has_node("HBoxContainer/SelectDecks"):
		header.get_node("HBoxContainer/SelectDecks").select(0)

func _populate_grid(grid: SpreadFlowContainer, card_ids: Array) -> void:
	var slots := grid.get_children()
	
	# Filter out non-card nodes (like scrollbars if they got mixed in)
	var valid_slots: Array[TextureRect] = []
	for child in slots:
		if child is TextureRect and child.has_method("setup"):
			valid_slots.append(child)
			
	# Make all valid slots active in the grid
	grid.set_visible_slot_count(valid_slots.size())
	
	for i in range(valid_slots.size()):
		if i < card_ids.size():
			var card_id: int = card_ids[i]
			var data := CardDatabase.get_card_data(card_id)
			
			if not data.is_empty():
				valid_slots[i].setup(data)
			else:
				valid_slots[i].clear_card()
		else:
			# Empty slot
			valid_slots[i].clear_card()
			
	# Force a layout update
	grid.queue_sort()

func _clear_grid(grid: SpreadFlowContainer) -> void:
	for child in grid.get_children():
		if child is TextureRect and child.has_method("clear_card"):
			child.clear_card()
	grid.queue_sort()
