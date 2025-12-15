extends CharacterBody2D

var is_selected: bool = false
@export var speed = 200
@onready var nav_agent = $NavigationAgent2D

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_selected = true
			print("Unit Selected")
	if is_selected and event.is_action_pressed("right_button"):
		nav_agent.target_position = get_global_mouse_position()
