class_name Mouse
extends Sprite2D

@export var input: PlayerInput

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !input.joystick_aim:
		global_position = get_global_mouse_position()
		visible = true
	else:
		visible = false
