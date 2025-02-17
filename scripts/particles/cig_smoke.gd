extends GPUParticles2D

@export var input: InputComponent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var abs_x: float = abs(position.x)
	if input.aim_direction.x < 0:
		position.x = -abs_x
	else:
		position.x = abs_x
