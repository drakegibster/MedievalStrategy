extends Node
class_name HealthComponent

signal health_changed(current_health, max_health)
signal health_depleated
signal damaged(amount)

@export var max_health: float = 100

@onready var current_health: float = max_health

func take_damage (amount: float):
	if current_health <= 0:
		return
		
	current_health =- amount
	# Ensures health cannot go below zero
	current_health = clamp(current_health, 0, max_health)
	
	emit_signal("damaged", amount)
	emit_signal("health_changed", current_health, max_health)
	
	if current_health <= 0:
		emit_signal("health_depleated")

func heal(amount: float):
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health, max_health)
