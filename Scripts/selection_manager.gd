extends Node

var selected_units: Array = [] #List of selected units

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			#handle_left_click()
			pass
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			#handle_right_click()
			pass

func get_unit_at_mouse(pos):
	#Creates an object that can run manual intersection tests outside of the normal physics loop
	var space_state = get_viewport().get_world_2d().direct_space_state
	
