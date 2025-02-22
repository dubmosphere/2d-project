class_name Main
extends Node

@export var enemy_scene: PackedScene

static var godmode: bool = false

func _ready() -> void:
	for child in SoundManager.get_children():
		if child is AudioStreamPlayer2D:
			SoundManager.remove_child(child)
			add_child(child)
	
	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	var spawn_location: Vector2 = Vector2(-216.0, -230.0)
	
	enemy.position = spawn_location
	
	add_child(enemy)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("pause"):
		get_tree().paused = false if get_tree().paused else true
	elif Input.is_action_just_pressed("toggle_godmode"):
		toggle_godmode()

func toggle_godmode() -> void:
	Main.godmode = !Main.godmode;
