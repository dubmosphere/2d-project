extends Sprite2D

@export var input: InputComponent

var initial_offset: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_offset = offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if input.looking_left:
		offset.y = -initial_offset.y
		flip_v = true
	else:
		offset.y = initial_offset.y
		flip_v = false
