extends CharacterBody2D

@export var speed: float = 300.0

func _physics_process(delta: float) -> void:
	# 1. Get the input direction (returns a Vector2)
	# This automatically handles WASD and Arrow keys if set in Input Map
	var direction = Input.get_vector("left", "right", "up", "down")
	# 2. Apply direction to velocity
	if direction:
		velocity = direction * speed
	else:
		# 3. Smoothly slow down to a stop if no keys are pressed
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	# 4. Built-in Godot function to move the body and handle collisions
	move_and_slide()
