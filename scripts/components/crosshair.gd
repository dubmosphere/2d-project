extends Sprite2D

@export var input: PlayerInput

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if input.joystick_aim:
		visible = true
	else:
		visible = false
