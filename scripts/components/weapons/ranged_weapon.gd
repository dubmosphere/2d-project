class_name RangedWeapon
extends Node

@export var actor: Entity
@export var bullet_offset: Marker2D
@export var input: InputComponent
@export var damage: int
@export var projectile_velocity: float
@export var bullets: int
@export var bullet_scene: PackedScene

var do_attack = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if input.attack:
		attack()

func attack() -> void:
	spawn_bullet()

func spawn_bullet() -> void:
	do_attack = false
	if !bullets && !Main.godmode:
		return
	bullets -= 1
	if Main.godmode:
		bullets = 9999
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.actor = actor
	bullet.position = bullet_offset.global_position
	bullet.direction = input.aim_direction
	bullet.rotation = input.aim_angle
	actor.get_parent().add_child(bullet)
