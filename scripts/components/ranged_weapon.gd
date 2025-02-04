class_name RangedWeapon
extends Node

@export var actor: Entity
@export var input: InputComponent
@export var damage: int
@export var projectile_velocity: float
@export var bullets: int
@export var bullet_scene: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attack()

func attack() -> void:
	if input.attack:
		spawn_bullet()

func spawn_bullet() -> void:
	if !bullets && !Main.godmode:
		return
	bullets -= 1
	if Main.godmode:
		bullets = 20
	
	var mouse_position: Vector2 = get_tree().root.get_node("Main/Map").get_global_mouse_position()
	var move_direction: Vector2 = actor.position.direction_to(mouse_position)
	var bullet: Bullet = bullet_scene.instantiate() as Bullet
	bullet.entity = actor
	bullet.position = actor.position
	bullet.direction = move_direction
	get_tree().root.add_child(bullet)
