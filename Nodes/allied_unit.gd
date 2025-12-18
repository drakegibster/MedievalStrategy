extends CharacterBody2D

var is_selected: bool = false
@export var speed = 200
@onready var nav_agent = $NavigationAgent2D
@onready var highlight = $SelectionHighlight

func set_selected(is_selected: bool):
	highlight.visible = is_selected

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_selected = true
			print("unit sellected")
