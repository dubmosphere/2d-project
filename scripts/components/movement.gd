class_name Movement
extends Node

@export var actor: CharacterBody2D
@export var input: InputComponent
@export var speed: float
@export var max_jump_count: int
@export var jump_velocity: float
@export var max_down_speed: float

var jump_count: int = 0
var velocity: Vector2 = Vector2(0.0, 0.0)
var last_velocity: Vector2 = Vector2(0.0, 0.0)
var just_landed: bool = false
var impact_velocity: Vector2 = Vector2(0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = actor.velocity
	handle_movement(delta)
	handle_landing()
	
	last_velocity = velocity
		
	actor.velocity = velocity
	
	if actor.move_and_slide() && actor.has_method("handle_collision"):
		actor.handle_collision(delta)

func handle_movement(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	move()

func apply_gravity(delta: float, force: bool = false) -> void:
	# Add the gravity.
	if !actor.is_on_floor() || (force):
		velocity += actor.get_gravity() * delta
	
	if velocity.y > max_down_speed:
		velocity.y = max_down_speed

func handle_jump() -> void:
	# Handle jump.
	if input.jump:
		jump()
	elif jump_count > 0 && actor.is_on_floor():
		jump_count = 0

func jump() -> void:
	var do_jump: bool = false
	
	if Main.godmode \
	  || actor.is_on_floor()\
	  || (jump_count > 0 && jump_count < max_jump_count && !actor.is_on_floor()):
		do_jump = true
	
	if !do_jump:
		return
	
	velocity.y = jump_velocity
	jump_count += 1

func move() -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction: float = input.direction
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func handle_landing() -> void:
	if velocity.y == 0 && last_velocity.y > 0 && actor.is_on_floor():
		just_landed = true
		impact_velocity.y = last_velocity.y
	else:
		if impact_velocity.y > 0:
			impact_velocity.y = 0
		just_landed = false
