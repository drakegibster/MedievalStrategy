extends Node

var selected_units: Array = [] #List of selected units

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			handle_left_click()
			pass
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			handle_right_click()
			pass

func handle_left_click():
	var mouse_pos = get_viewport().get_mouse_position()
	# Gets a unit using the get unit function which takes the mouse position as an input
	var unit = get_unit_at_mouse(mouse_pos)
	if unit != null:
		if not Input.is_key_pressed(KEY_SHIFT):
			deselect_all()
		select_unit(unit)
	else:
		deselect_all()

func handle_right_click():
	var move_pos = get_viewport().get_mouse_position()
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
