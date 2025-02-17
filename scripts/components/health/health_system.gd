class_name HealthSystem
extends Node

@export var health: int
var max_health: int = 0
var health_percentage: int = 0

func _ready() -> void:
	max_health = health
	evaluate_health_percentage()

func apply_dammage(damage: int) -> void:
	health -= damage
	evaluate_health_percentage()

func evaluate_health_percentage() -> void:
	health_percentage = int(float(health) / float(max_health) * 100)
