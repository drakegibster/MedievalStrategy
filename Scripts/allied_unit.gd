extends CharacterBody2D

var is_selected: bool = false
@export var speed = 200
@onready var nav_agent = $NavigationAgent2D
@onready var highlight = $SelectionHighlight

func _ready() -> void:
	deselect()

func select(state: bool):
	is_selected = state
	highlight.visible = true
	print("unit selected")

func deselect():
	is_selected = false
	highlight.visible = false
	print("unit deselected")

func move_to(pos):
	print("unit will move to", pos)
