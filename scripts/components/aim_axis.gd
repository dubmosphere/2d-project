class_name AimAxis
extends Marker2D

@export var input: InputComponent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation = input.aim_angle
