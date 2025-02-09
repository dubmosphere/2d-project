extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var quarter_circle: float = PI / 2
	if global_rotation > quarter_circle || global_rotation < -quarter_circle:
		flip_v = true
	else:
		flip_v = false
