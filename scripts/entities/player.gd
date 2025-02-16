class_name Player
extends Entity

@export var id: int = 0

@onready var animation_tree: AnimationTree = $Sprite/AnimationTree
@onready var input: PlayerInput = $PlayerInput
@onready var movement: Movement = $Movement

var animation_state_machine: AnimationNodeStateMachinePlayback

func _ready() -> void:
	animation_state_machine = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	initialize_animations()

func initialize_animations() -> void:
	animation_tree.set("parameters/idle/blend_position", input.aim_direction)
	animation_tree.set("parameters/walk/blend_position", input.aim_direction)
	animation_tree.set("parameters/jump_up/blend_position", input.aim_direction)
	animation_tree.set("parameters/jump_down/blend_position", input.aim_direction)
	animation_state_machine.travel("idle")

func _process(_delta: float) -> void:
	handle_animations()
	if movement.just_jumped:
		SoundManager.play_jump_sound()

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
	if input.aim_direction.x != 0:
		animation_tree.set("parameters/idle/blend_position", input.aim_direction.x)
		animation_tree.set("parameters/walk/blend_position", input.aim_direction.x)
		animation_tree.set("parameters/jump_up/blend_position", input.aim_direction.x)
		animation_tree.set("parameters/jump_down/blend_position", input.aim_direction.x)

#func handle_collision() -> void:
	#if !get_slide_collision_count():
		#return
	#
	#for index in get_slide_collision_count():
		#var collision: KinematicCollision2D = get_slide_collision(index)
		#if collision.get_collider() is TileMapLayer:
			#handle_tile_collision(collision)
#
#func handle_tile_collision(collision: KinematicCollision2D) -> void:
	#var normal: Vector2 = collision.get_normal()
	#var is_on_slope: bool = normal.y != -1
	## todo: check angle...
	#if !movement.just_jumped && is_on_slope && !is_on_wall() && !is_on_ceiling() && !input.jump && velocity.x == 0:
		#velocity.y = 0.0
