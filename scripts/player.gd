class_name Player
extends Entity

@export var player_number: int
@export var player_joypad: int

const SPEED: float = 570.0
const JUMP_VELOCITY: float = -610.0
const MAX_DOWN_SPEED: float = 1500.0
const FF_ON: bool = true
const FF_INTENSITY: float = 0.5

var animation_tree: AnimationTree
var animation_state_machine: AnimationNodeStateMachinePlayback
var jump_sound: AudioStreamPlayer2D

var joypads: Array
var joypad = null
var max_jumps: int = 2
var jump_count: int = 0
var last_velocity: Vector2 = Vector2(0.0, 0.0)

func _ready() -> void:
	animation_tree = $Sprite/AnimationTree as AnimationTree
	animation_state_machine = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	jump_sound = $JumpSound as AudioStreamPlayer2D
	
	joypads = Input.get_connected_joypads()
	for j in joypads:
		if(joypad == player_joypad):
			joypad = player_joypad
		
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
	handle_movement(delta)
	handle_ff()
	handle_animations()
	
	last_velocity = velocity
	
	if move_and_slide():
		handle_collision(delta)
		
	var space_state = get_world_2d().direct_space_state
	var ray_query_parameters: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		position,
		position + velocity
	)
	var result = space_state.intersect_ray(ray_query_parameters)

func handle_movement(delta: float) -> void:
	handle_shooting()
	apply_gravity(delta)
	handle_jump()
	move()

func handle_shooting() -> void:
	if Input.is_action_just_pressed("shoot"):
		var main: Main = $"..";
		main.spawn_bullet(self)
	

func apply_gravity(delta: float, force: bool = false) -> void:
	# Add the gravity.
	if !is_on_floor() || (force):
		velocity += get_gravity() * delta
	
	if velocity.y > MAX_DOWN_SPEED:
		velocity.y = MAX_DOWN_SPEED

func handle_jump() -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump()
	elif jump_count > 0 && is_on_floor():
		jump_count = 0

func jump() -> void:
	var do_jump: bool = false
	
	if Main.godmode \
	  || is_on_floor()\
	  || (jump_count > 0 && jump_count < max_jumps && !is_on_floor()):
		do_jump = true
	
	if !do_jump:
		return
	
	velocity.y = JUMP_VELOCITY
	jump_sound.play()
	jump_count += 1

func move() -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction: float = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_ff() -> void:
	if !FF_ON || FF_INTENSITY == 0.0 || joypad == null:
		return
	
	if velocity.y == 0 && last_velocity.y > 0 && is_on_floor():
		var ffAmount: float = get_ff_amount(FF_INTENSITY, MAX_DOWN_SPEED, last_velocity.y)
		Input.start_joy_vibration(joypad, ffAmount, ffAmount, ffAmount)

func get_ff_amount(intensity, max_down_speed, down_speed) -> float:
	if max_down_speed == 0 || down_speed == 0:
		return 0
	
	return intensity / max_down_speed * down_speed

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
