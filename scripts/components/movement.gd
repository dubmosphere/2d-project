class_name Movement
extends Node

@export var actor: CharacterBody2D
@export var input: InputComponent
@export var speed: float
@export var max_jump_count: int
@export var jump_velocity: float
@export var max_down_speed: float

var direction: float = 0.0
var do_jump: bool = false
var jump_count: int = 0
var velocity: Vector2 = Vector2(0.0, 0.0)
var last_velocity: Vector2 = Vector2(0.0, 0.0)
var just_landed: bool = false
var just_jumped: bool = false
var impact_velocity: Vector2 = Vector2(0.0, 0.0)

func _process(_delta: float) -> void:
	if  input.jump && !do_jump:
		do_jump = input.jump
	
	direction = input.direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = actor.velocity
	
	apply_gravity(delta)
	handle_jump()
	handle_landing()
	handle_movement()
	
	actor.velocity = velocity
	
	if actor.move_and_slide() && actor.has_method("handle_collision"):
		# TODO: actor emit signal _on_collision_after_move_and_slide or whatever...
		actor.handle_collision()
	
	last_velocity = velocity

func apply_gravity(delta: float, force: bool = false) -> void:
	# Add the gravity.
	if !actor.is_on_floor() || force:
		velocity += actor.get_gravity() * delta
	
	if velocity.y > max_down_speed:
		velocity.y = max_down_speed

func handle_jump() -> void:
	just_jumped = false
	# Handle jump.
	if do_jump:
		jump()
	elif jump_count > 0 && actor.is_on_floor():
		jump_count = 0

func jump() -> void:
	do_jump = false
	
	if Main.godmode \
	  || actor.is_on_floor()\
	  || (jump_count > 0 && jump_count < max_jump_count && !actor.is_on_floor()):
		do_jump = true
	
	if !do_jump:
		return
	velocity.y = jump_velocity
	jump_count += 1
	just_jumped = true
	do_jump = false

func handle_landing() -> void:
	if velocity.y == 0 && last_velocity.y > 0 && actor.is_on_floor():
		just_landed = true
		impact_velocity.y = last_velocity.y
	else:
		if impact_velocity.y > 0:
			impact_velocity.y = 0
		just_landed = false

func handle_movement() -> void:
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
