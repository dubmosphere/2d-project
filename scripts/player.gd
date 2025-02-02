extends CharacterBody2D

const World = preload("res://scripts/world.gd")

const SPEED = 570.0
const JUMP_VELOCITY = -610.0
const MAX_DOWN_SPEED = 1500.0
const FF_INTENSITY = 0.5

var animation_tree: AnimationTree
var animation_state_machine: AnimationNodeStateMachinePlayback
var jump_sound: AudioStreamPlayer2D

var joypads: Array
var joypad = null
var jump_count = 0
var last_velocity = Vector2(0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_tree = $Sprite/AnimationTree as AnimationTree
	animation_state_machine = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	jump_sound = $JumpSound as AudioStreamPlayer2D
	joypads = Input.get_connected_joypads()
	if joypads.size():
		joypad = Input.get_connected_joypads()[0]
	initialize_animations()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("pause"):
		get_tree().paused = false if get_tree().paused else true
	elif Input.is_action_just_pressed("toggle_godmode"):
		toggle_godmode()

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_ff()
	handle_animations()
	
	last_velocity = velocity
	
	move_and_slide()

func initialize_animations() -> void:
	animation_tree.set("parameters/idle/blend_position", 1)
	animation_tree.set("parameters/walk/blend_position", 1)
	animation_tree.set("parameters/jump_up/blend_position", 1)
	animation_tree.set("parameters/jump_down/blend_position", 1)
	animation_state_machine.travel("idle")

func handle_movement(delta: float) -> void:
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if(World.godmode || is_on_floor()):
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
			jump_count += 1
		elif jump_count > 0 && jump_count < 2 && !is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
			jump_count += 1
	elif jump_count > 0 && is_on_floor():
		jump_count = 0
	
	if velocity.y > MAX_DOWN_SPEED:
		velocity.y = MAX_DOWN_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func handle_ff() -> void:
	if joypad == null || FF_INTENSITY == 0:
		return
	if velocity.y == 0 && last_velocity.y > 0 && is_on_floor():
		var ffAmount = get_ff_amount(FF_INTENSITY, MAX_DOWN_SPEED, last_velocity.y)
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

# Set blend positions by velocity.x
func update_blend_positions() -> void:
	if velocity.x != 0:
		animation_tree.set("parameters/idle/blend_position", velocity.x)
		animation_tree.set("parameters/walk/blend_position", velocity.x)
		animation_tree.set("parameters/jump_up/blend_position", velocity.x)
		animation_tree.set("parameters/jump_down/blend_position", velocity.x)

func toggle_godmode() -> void:
	World.godmode = !World.godmode;
