class_name JoypadAim
extends Aim

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if input.joystick_aim:
		visible = true
	else:
		visible = false
