class_name Main
extends Node

@export var enemy_scene: PackedScene
@export var bullet_scene: PackedScene
static var godmode: bool = false

func _ready() -> void:
	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	var spawnLocation: Vector2 = Vector2(0.0, 0.0)
	var world = $HBoxContainer/SubViewportContainer1/SubViewport1.find_world_2d()
	$HBoxContainer/SubViewportContainer2/SubViewport2.world_2d = world
	enemy.position = spawnLocation
	
	add_child(enemy)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("pause"):
		get_tree().paused = false if get_tree().paused else true
	elif Input.is_action_just_pressed("toggle_godmode"):
		toggle_godmode()

func toggle_godmode() -> void:
	Main.godmode = !Main.godmode;
