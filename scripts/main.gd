class_name Main
extends Node

@export var enemy_scene: PackedScene
@export var bullet_scene: PackedScene

@onready var sub_viewport1: SubViewport = $VBoxContainer/HBoxContainer/SubViewportContainer1/SubViewport1
@onready var sub_viewport2: SubViewport = $VBoxContainer/HBoxContainer/SubViewportContainer2/SubViewport2
@onready var sub_viewport3: SubViewport = $VBoxContainer/HBoxContainer2/SubViewportContainer3/SubViewport3
@onready var sub_viewport4: SubViewport = $VBoxContainer/HBoxContainer2/SubViewportContainer4/SubViewport4

static var godmode: bool = false

func _ready() -> void:
	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	var spawn_location: Vector2 = Vector2(-216.0, 230.0)
	
	enemy.position = spawn_location
	
	if sub_viewport1:
		var world = sub_viewport1.find_world_2d()
		sub_viewport2.world_2d = world
		sub_viewport3.world_2d = world
		sub_viewport4.world_2d = world
		sub_viewport1.add_child(enemy)
	else:
		$/root/Main.add_child(enemy)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("pause"):
		get_tree().paused = false if get_tree().paused else true
	elif Input.is_action_just_pressed("toggle_godmode"):
		toggle_godmode()

func toggle_godmode() -> void:
	Main.godmode = !Main.godmode;
