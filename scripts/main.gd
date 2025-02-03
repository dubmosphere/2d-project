class_name Main
extends Node

@export var enemy_scene: PackedScene
static var godmode: bool = false

func _ready() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	var spawnLocation: Vector2 = Vector2(0.0, 0.0)
	
	enemy.position = spawnLocation
	
	add_child(enemy)

func _process(delta: float) -> void:
	pass
