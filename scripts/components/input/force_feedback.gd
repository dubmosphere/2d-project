class_name ForceFeedback
extends Node

@export var movement: Movement
@export var input: PlayerInput
@export var on: bool
@export var intensity: float

var joypad = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	joypad = input.joypad


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if joypad != null:
		handle_ff()

func handle_ff() -> void:
	if !on || intensity == 0.0 || joypad == null:
		return
	if movement.just_landed:
		var ffAmount: float = get_ff_amount(intensity, movement.max_down_speed, movement.impact_velocity.y)
		Input.start_joy_vibration(joypad, ffAmount, ffAmount, ffAmount)

func get_ff_amount(ff_intensity, max_down_speed, down_speed) -> float:
	if max_down_speed == 0 || down_speed == 0:
		return 0
	
	return ff_intensity / max_down_speed * down_speed
