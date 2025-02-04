class_name HealthSystem
extends Node

@export var health: int

func apply_dammage(damage: int) -> void:
	health -= damage
