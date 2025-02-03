class_name Main
extends Node

@export var enemy_scene: PackedScene
@export var bullet_scene: PackedScene
static var godmode: bool = false

func _ready() -> void:
	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	var spawnLocation: Vector2 = Vector2(0.0, 0.0)
	
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

func spawn_bullet(entity: Entity) -> void:
	if !entity.bullets && !Main.godmode:
		return
	entity.bullets -= 1
	if Main.godmode:
		entity.bullets = 20
	
	var mouse_position: Vector2 = $Map.get_global_mouse_position()
	var offset_direction: Vector2 = entity.position.direction_to(mouse_position)
	var bullet_offset: Vector2 = Vector2(30, 55) * offset_direction
	var bullet_position: Vector2 = entity.position + bullet_offset
	var move_direction: Vector2 = bullet_position.direction_to(mouse_position)
	var bullet: Bullet = bullet_scene.instantiate() as Bullet
	bullet.entity = entity
	bullet.position = bullet_position
	bullet.direction = move_direction
	add_child(bullet)
