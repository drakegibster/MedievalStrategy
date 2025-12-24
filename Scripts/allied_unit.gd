extends CharacterBody2D

var is_selected: bool = false
@export var speed = 50
@onready var nav_agent = $NavigationAgent2D
@onready var highlight = $SelectionHighlight

func _ready() -> void:
	deselect()

func _physics_process(delta: float) -> void:
	# Stop if we have arrived
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	# Get the enxt point in our path
	var next_path_pos = nav_agent.get_next_path_position()
	#Calculate direction and velocity
	var direction = global_position.direction_to(next_path_pos)
	velocity = direction * speed
	move_and_slide()

func select(state: bool):
	is_selected = state
	highlight.visible = true
	print("unit selected")

func deselect():
	is_selected = false
	highlight.visible = false
	print("unit deselected")

func move_to(pos):
	nav_agent.set_target_position(pos)
