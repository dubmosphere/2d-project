class_name PlayerInput
extends InputComponent

@export var player: Player

var joypad = null
var i: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for j in Input.get_connected_joypads():
		if(j == player.player_number):
			joypad = j




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player.player_number == 0 || joypad != null:
		var joypad_str = str(player.player_number)
		direction = Input.get_axis("left_" + joypad_str, "right_" + joypad_str)
		jump = Input.is_action_just_pressed("jump_" + joypad_str)
		attack = Input.is_action_just_pressed("attack_" + joypad_str)
