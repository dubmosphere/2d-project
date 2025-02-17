class_name AimAxis
extends Marker2D

@export var input: InputComponent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(global_position + input.aim_direction)
