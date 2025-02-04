class_name PlayerInput
extends InputComponent

@export var player_joypad: int

var joypads: Array
var joypad: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	joypads = Input.get_connected_joypads()
	for j in joypads:
		if(joypad == player_joypad):
			joypad = player_joypad


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	jump = Input.is_action_just_pressed("jump")
	attack = Input.is_action_just_pressed("attack")
