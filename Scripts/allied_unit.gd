extends CharacterBody2D

var is_selected: bool = false
@export var speed = 200
@onready var nav_agent = $NavigationAgent2D
@onready var highlight = $SelectionHighlight

func _ready() -> void:
	deselect_unit()

func select_unit():
	is_selected = true
	highlight.visible = true
	print("unit selected")

func deselect_unit():
	is_selected = false
	highlight.visible = false
	print("unit deselected")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_unit()

func _unhandled_input(event):
	if is_selected and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var target_pos = get_global_mouse_position()
			print("moving to", target_pos)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			deselect_unit()
