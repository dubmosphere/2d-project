class_name RangedWeapon
extends Node

@export var actor: Entity
@export var input: InputComponent
@export var damage: int
@export var projectile_velocity: float
@export var bullets: int
@export var bullet_scene: PackedScene

@onready var sub_viewport: SubViewport = $/root/Main/VBoxContainer/HBoxContainer/SubViewportContainer1/SubViewport1
@onready var map: Map = $/root/Main/Map

func _ready() -> void:
	if sub_viewport:
		map = sub_viewport.get_node('Map')

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
	bullet.entity = actor
	bullet.position = actor.position
	bullet.direction = input.aim_direction
	map.get_parent().add_child(bullet)
