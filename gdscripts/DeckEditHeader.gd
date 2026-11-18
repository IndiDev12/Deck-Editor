extends Control

signal deck_loaded(deck_data: Dictionary)

@onready var select_decks: OptionButton = $HBoxContainer/SelectDecks
var _item_to_path: Array[String] = []
const PLACEHOLDER := "(select deck)"

func _ready() -> void:
	refresh_deck_list()
	if not select_decks.item_selected.is_connected(_on_deck_selected):
		select_decks.item_selected.connect(_on_deck_selected)

func refresh_deck_list() -> void:
	select_decks.clear()
	_item_to_path.clear()
	select_decks.add_item(PLACEHOLDER)
	select_decks.set_item_disabled(0, true)
	_item_to_path.append("")
	
	var listing := YdkParser.list_decks()
	for i in listing.paths.size():
		select_decks.add_item(listing.names[i])
		_item_to_path.append(listing.paths[i])
		
	select_decks.select(0)

func _on_deck_selected(index: int) -> void:
	if index < 0 or index >= _item_to_path.size(): return
	var path := _item_to_path[index]
	if path.is_empty(): return
	
	var parsed := YdkParser.parse_file(path)
	deck_loaded.emit({
		"name": select_decks.get_item_text(index),
		"path": path,
		"main": parsed["main"],
		"extra": parsed["extra"],
		"side": parsed["side"]
	})
