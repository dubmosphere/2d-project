class_name RangedWeapon
extends Node

@export var actor: Entity
@export var offset: Marker2D
@export var input: InputComponent
@export var damage: int
@export var projectile_velocity: float
@export var bullets: int
@export var bullet_scene: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	attack()

func attack() -> void:
	if input.attack:
		spawn_bullet()

func spawn_bullet() -> void:
	if !bullets && !Main.godmode:
		return
	bullets -= 1
	if Main.godmode:
		bullets = 9999
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.actor = actor
	bullet.position = offset.global_position
	bullet.direction = input.aim_direction
	actor.get_parent().add_child(bullet)
