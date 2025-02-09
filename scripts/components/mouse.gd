class_name Mouse
extends Sprite2D

@export var input: PlayerInput

func _ready() -> void:
	var player_layer = input.player.player_number + 1
	if player_layer > 1 && input.joypad == null:
		visibility_layer = 0
	else:
		visibility_layer = 2 ** player_layer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	if !input.joystick_aim:
		visible = true
	else:
		visible = false
