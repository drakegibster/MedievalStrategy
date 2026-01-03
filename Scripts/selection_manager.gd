extends Node2D

@onready var camera = $"../PlayerCam"
var dragging = false
var drag_start = Vector2.ZERO
var drag_end = Vector2.ZERO
var selected_units: Array = [] #List of selected units

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start Drag
				dragging = true
				drag_start = get_global_mouse_position()
				drag_end = get_global_mouse_position()
			elif dragging:
				# End Drag
				dragging = false
				drag_end = get_global_mouse_position()
				queue_redraw() # Hide the box
				select_units_in_box() # Run the physics check
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			handle_right_click()
	if event is InputEventMouseMotion and dragging:
		# Update Drag
		drag_end = get_global_mouse_position() # Updates the drag_end part variable, NOT the drag_start var
		queue_redraw() # Updates the visual box

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, drag_end - drag_start), Color(0, 1, 0, 0.2), true)
		draw_rect(Rect2(drag_start, drag_end - drag_start), Color(0, 1, 0, 0.5), false, 2.0)

func handle_left_click():
	var mouse_pos = get_global_mouse_position()
	# Gets a unit using the get unit function which takes the mouse position as an input
	var unit = get_unit_at_mouse(mouse_pos)
	if unit != null:
		if not Input.is_key_pressed(KEY_SHIFT):
			deselect_all()
		select_unit(unit)
	else:
		deselect_all()

func handle_right_click():
	var move_pos = camera.get_global_mouse_position()
	for unit in selected_units:
		if unit.has_method("move_to"):
			unit.move_to(move_pos)
		else:
			pass

func deselect_all():
	for unit in selected_units:
		if is_instance_valid(unit) and unit.has_method("deselect"):
			unit.deselect()
	selected_units.clear()

func select_unit(unit):
	unit.select(true)
	selected_units.append(unit)

func select_units_in_box():
	# 1. Don't select if the box is too small (accidental click)
	if drag_start.distance_to(drag_end) < 10:
		var found_unit = get_unit_at_mouse(drag_start)
		if found_unit: select_unit(found_unit)
		return
	# 2. Deselect olf units if not holding shift
	if not Input.is_key_pressed(KEY_SHIFT):
		deselect_all()
	# 3. Setup the Physics Shape Query
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	# 4. Define the rectangle shape
	var box = RectangleShape2D.new()
	box.size = abs(drag_end - drag_start) # Size must be positive
	query.shape = box
	# 5. Find the center point in world coordinates
	var center_screen = (drag_start + drag_end) / 2
	var center_world = get_viewport().get_canvas_transform().affine_inverse() * center_screen
	query.transform = Transform2D(0, center_world)
	query.collision_mask = 2 # Get units on layer 2
	# 6. Execute the query
	var results = space_state.intersect_shape(query)
	for data in results:
		var unit = data.collider
		if unit.has_method("select"):
			select_unit(unit)

func get_unit_at_mouse(pos):
	#Creates an object that can run manual intersection tests outside of the normal physics loop
	var space_state = get_viewport().get_world_2d().direct_space_state
	#Translates mouse position
	var world_pos = get_viewport().get_canvas_transform().affine_inverse() * pos
	#Define a query that checks collision layer 2
	var query = PhysicsPointQueryParameters2D.new()
	query.position = world_pos
	query.collision_mask = 2
	#Execute the query
	var results = space_state.intersect_point(query)
	#Return
	if results.size() > 0:
		return results[0].collider
	return null
