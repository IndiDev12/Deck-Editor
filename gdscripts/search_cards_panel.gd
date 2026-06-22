extends Panel

@onready var h_flow_container: HFlowContainer = $HBoxContainer/HFlowContainer

func _ready() -> void:
	resized.connect(h_flow_container._update_visible_items)
	h_flow_container._update_visible_items()
