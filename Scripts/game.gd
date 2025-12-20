extends Node2D

@onready var camera = $PlayerCam
@onready var player = $Player

func _ready() -> void:
	player.remote_transform.remote_path = camera.get_path()
