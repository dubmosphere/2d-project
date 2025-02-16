class_name PlayerInput
extends InputComponent

@export var player: Player

var joypad = null
var joystick_aim: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for j in Input.get_connected_joypads():
		if j == player.id:
			joypad = j

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.id == 0 || joypad != null:
		click = Input.is_action_just_pressed("click")
		jump = Input.is_action_just_pressed("jump_%s" % player.id)
		attack = Input.is_action_just_pressed("attack_%s" % player.id)
		direction = Input.get_axis(
			"left_%s" % player.id,
			"right_%s" % player.id
		)
	
		var input_aim_direction: Vector2 = Input.get_vector(
			"aim_left_%s" % player.id,
			"aim_right_%s" % player.id,
			"aim_up_%s" % player.id,
			"aim_down_%s" % player.id
		)
		
		if Input.get_last_mouse_velocity() != Vector2.ZERO:
			joystick_aim = false
		
		if player.id == 0 && !joystick_aim:
			var mouse_position: Vector2 = player.get_global_mouse_position()
			aim_direction = player.position.direction_to(mouse_position)
		
		if input_aim_direction != Vector2.ZERO:
			aim_direction = input_aim_direction.normalized()
			joystick_aim = true
		
		if joypad != null && joypad > 0:
			joystick_aim = true
		
		aim_angle = Vector2.ZERO.angle_to_point(aim_direction)
		
		if aim_direction.x < 0:
			looking_left = true
		else:
			looking_left = false
