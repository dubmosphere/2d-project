class_name Splitscreen
extends Node

@export var enemy_scene: PackedScene
@export var bullet_scene: PackedScene

@onready var sub_viewport1: SubViewport = $VBoxContainer/HBoxContainer1/SubViewportContainer1/SubViewport1
@onready var sub_viewport2: SubViewport = $VBoxContainer/HBoxContainer1/SubViewportContainer2/SubViewport2
@onready var sub_viewport3: SubViewport = $VBoxContainer/HBoxContainer2/SubViewportContainer3/SubViewport3
@onready var sub_viewport4: SubViewport = $VBoxContainer/HBoxContainer2/SubViewportContainer4/SubViewport4

func _ready() -> void:
	var world = sub_viewport1.find_world_2d()
	sub_viewport2.world_2d = world
	sub_viewport3.world_2d = world
	sub_viewport4.world_2d = world
	
	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	var spawn_location: Vector2 = Vector2(-216.0, 230.0)
	
	enemy.position = spawn_location
	sub_viewport1.add_child(enemy)

func _process(_delta: float) -> void:
	#print("FPS: %s (MSPF: %s)" % [Engine.get_frames_per_second(), _delta])
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("pause"):
		get_tree().paused = false if get_tree().paused else true
	elif Input.is_action_just_pressed("toggle_godmode"):
		toggle_godmode()
	
func toggle_godmode() -> void:
	Main.godmode = !Main.godmode;
