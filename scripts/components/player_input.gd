class_name PlayerInput
extends InputComponent

@export var player: Player

@onready var sub_viewport: SubViewport = $/root/Main/VBoxContainer/HBoxContainer/SubViewportContainer1/SubViewport1
@onready var map: Map = $/root/Main/Map

var joypad = null
var last_aim_direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sub_viewport:
		map = sub_viewport.get_node('Map')
	for j in Input.get_connected_joypads():
		if(j == player.player_number):
			joypad = j

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player.player_number == 0 || joypad != null:
		var joypad_str = str(player.player_number)
		click = Input.is_action_just_pressed("click")
		jump = Input.is_action_just_pressed("jump_" + joypad_str)
		attack = Input.is_action_just_pressed("attack_" + joypad_str)
	
		direction = Input.get_axis("left_" + joypad_str, "right_" + joypad_str)
	
		var input_aim_direction: Vector2
		input_aim_direction.x = Input.get_axis("aim_left_" + joypad_str, "aim_right_" + joypad_str)
		input_aim_direction.y = -Input.get_axis("aim_down_" + joypad_str, "aim_up_" + joypad_str)
		print(input_aim_direction, input_aim_direction.angle_to(Vector2(0, 0)))
		#todo: Make this vector work without adjusting the speed of the projectile
	
		if input_aim_direction != Vector2.ZERO:
			aim_direction = input_aim_direction
		
		if click:
			var mouse_position: Vector2 = map.get_global_mouse_position()
			aim_direction = player.position.direction_to(mouse_position)
	
		last_aim_direction = aim_direction
