class_name Splitscreen
extends Node

@export var enemy_scene: PackedScene
@export var bullet_scene: PackedScene

@onready var sub_viewport1: SubViewport = $VBoxContainer/HBoxContainer/SubViewportContainer1/SubViewport1
@onready var sub_viewport2: SubViewport = $VBoxContainer/HBoxContainer/SubViewportContainer2/SubViewport2
@onready var sub_viewport3: SubViewport = $VBoxContainer/HBoxContainer2/SubViewportContainer3/SubViewport3
@onready var sub_viewport4: SubViewport = $VBoxContainer/HBoxContainer2/SubViewportContainer4/SubViewport4
@onready var player: Player = $VBoxContainer/HBoxContainer/SubViewportContainer1/SubViewport1/Player
@onready var player2: Player = $VBoxContainer/HBoxContainer/SubViewportContainer2/SubViewport2/Player2
@onready var player3: Player = $VBoxContainer/HBoxContainer2/SubViewportContainer3/SubViewport3/Player3
@onready var player4: Player = $VBoxContainer/HBoxContainer2/SubViewportContainer4/SubViewport4/Player4

static var godmode: bool = false

func _ready() -> void:
	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	var spawn_location: Vector2 = Vector2(-216.0, 230.0)
	
	enemy.position = spawn_location
	
	var world = sub_viewport1.find_world_2d()
	sub_viewport2.world_2d = world
	sub_viewport3.world_2d = world
	sub_viewport4.world_2d = world
	player.get_node("Components/AimAxis/Mouse").visibility_layer = 2
	player.get_node("Components/AimAxis/Crosshair").visibility_layer = 2
	player2.get_node("Components/AimAxis/Crosshair").visibility_layer = 4
	player3.get_node("Components/AimAxis/Crosshair").visibility_layer = 8
	player4.get_node("Components/AimAxis/Crosshair").visibility_layer = 16
	sub_viewport1.add_child(enemy)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("pause"):
		get_tree().paused = false if get_tree().paused else true
	elif Input.is_action_just_pressed("toggle_godmode"):
		toggle_godmode()

func toggle_godmode() -> void:
	Main.godmode = !Main.godmode;
