class_name Crosshair
extends Sprite2D

@export var input: PlayerInput

func _ready() -> void:
	var player_layer = input.player.player_number + 1
	if player_layer > 1 && input.joypad == null:
		visibility_layer = 0
	else:
		visibility_layer = 1 << player_layer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if input.joystick_aim:
		visible = true
	else:
		visible = false
