class_name MouseAim
extends Aim

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	if !input.joystick_aim:
		visible = true
	else:
		visible = false
