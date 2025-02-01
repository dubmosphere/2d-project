extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ready")
	initialize_animations()

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_animations()
	move_and_slide()
	handle_collision()

func initialize_animations() -> void:
	$Sprite2D/PlayerAnimationTree.set("parameters/Idle/blend_position", 1)
	$Sprite2D/PlayerAnimationTree.set("parameters/Walk/blend_position", 1)
	$Sprite2D/PlayerAnimationTree.set("parameters/JumpUp/blend_position", 1)
	$Sprite2D/PlayerAnimationTree.set("parameters/JumpDown/blend_position", 1)
	$Sprite2D/PlayerAnimationTree.get("parameters/playback").travel("Idle")

func handle_movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func handle_collision() -> void:
	var floor_normal = get_floor_normal()
	var floor_angle = get_floor_angle()
	var last_collision = get_last_slide_collision()
	
	if(last_collision):
		print(last_collision.get_collider())
	
func handle_animations() -> void:
	if(!is_on_floor()):
		if(velocity.y < 0):
			$Sprite2D/PlayerAnimationTree.get("parameters/playback").travel("JumpUp")
		else:
			$Sprite2D/PlayerAnimationTree.get("parameters/playback").travel("JumpDown")
	else:	
		if(velocity.x == 0):
			$Sprite2D/PlayerAnimationTree.get("parameters/playback").travel("Idle")
		else:
			$Sprite2D/PlayerAnimationTree.get("parameters/playback").travel("Walk")
	
	update_blendpositions()

func update_blendpositions() -> void:
	if(velocity.x != 0):
		$Sprite2D/PlayerAnimationTree.set("parameters/Idle/blend_position", velocity.x)
		$Sprite2D/PlayerAnimationTree.set("parameters/Walk/blend_position", velocity.x)
		$Sprite2D/PlayerAnimationTree.set("parameters/JumpUp/blend_position", velocity.x)
		$Sprite2D/PlayerAnimationTree.set("parameters/JumpDown/blend_position", velocity.x)
