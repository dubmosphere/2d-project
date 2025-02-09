class_name PlayerInput
extends InputComponent

@export var player: Player

var joypad = null
var joystick_aim = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for j in Input.get_connected_joypads():
		if j == player.player_number:
			joypad = j

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if player.player_number == 0 || joypad != null:
		click = Input.is_action_just_pressed("click")
		jump = Input.is_action_just_pressed("jump_%s" % player.player_number)
		attack = Input.is_action_just_pressed("attack_%s" % player.player_number)
		direction = Input.get_axis(
			"left_%s" % player.player_number,
			"right_%s" % player.player_number
		)
	
		var input_aim_direction: Vector2 = Input.get_vector(
			"aim_left_%s" % player.player_number,
			"aim_right_%s" % player.player_number,
			"aim_up_%s" % player.player_number,
			"aim_down_%s" % player.player_number
		)
		
		if Input.get_last_mouse_velocity() != Vector2.ZERO:
			joystick_aim = false
		
		if player.player_number == 0 && !joystick_aim:
			var mouse_position: Vector2 = player.get_global_mouse_position()
			aim_direction = player.position.direction_to(mouse_position)
		
		if input_aim_direction != Vector2.ZERO:
			aim_direction = input_aim_direction.normalized()
			joystick_aim = true
		
		if joypad != null && joypad > 0:
			joystick_aim = true
		
		aim_angle = Vector2.ZERO.angle_to_point(aim_direction)
