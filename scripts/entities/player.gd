class_name Player
extends Entity

@export var player_number: int

@onready var animation_tree: AnimationTree = $Sprite/AnimationTree
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var input: PlayerInput = $Components/PlayerInput
@onready var movement: Movement = $Components/Movement

var animation_state_machine: AnimationNodeStateMachinePlayback

func _ready() -> void:
	animation_state_machine = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
		
	initialize_animations()

func initialize_animations() -> void:
	animation_tree.set("parameters/idle/blend_position", 1)
	animation_tree.set("parameters/walk/blend_position", 1)
	animation_tree.set("parameters/jump_up/blend_position", 1)
	animation_tree.set("parameters/jump_down/blend_position", 1)
	animation_state_machine.travel("idle")

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	handle_animations()
	if movement.just_jumped:
		jump_sound.play()

func handle_animations() -> void:
	if !is_on_floor():
		if velocity.y < 0:
			animation_state_machine.travel("jump_up")
		else:
			animation_state_machine.travel("jump_down")
	else:
		if velocity.x == 0:
			animation_state_machine.travel("idle")
		else:
			animation_state_machine.travel("walk")
	
	update_blend_positions()

func update_blend_positions() -> void:
	# Set blend positions by velocity.x
	if velocity.x != 0:
		animation_tree.set("parameters/idle/blend_position", velocity.x)
		animation_tree.set("parameters/walk/blend_position", velocity.x)
		animation_tree.set("parameters/jump_up/blend_position", velocity.x)
		animation_tree.set("parameters/jump_down/blend_position", velocity.x)

func handle_collision(delta: float) -> void:
	if !get_slide_collision_count():
		return
	
	for index in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(index)
		if collision.get_collider() is Enemy:
			handle_enemy_collision(collision)
		if collision.get_collider() is TileMapLayer:
			handle_tile_collision(collision, delta)

func handle_enemy_collision(collision: KinematicCollision2D) -> void:
	var enemy: Enemy = collision.get_collider() as Enemy
	var shape: CollisionPolygon2D = enemy.get_node("Hitbox")
	
func handle_tile_collision(collision: KinematicCollision2D, delta: float) -> void:
	var normal: Vector2 = collision.get_normal()
	var is_on_slope: bool = normal.y != -1
	# todo: check angle...
	if is_on_slope && velocity.y < 0:
		velocity.y = 0.0
