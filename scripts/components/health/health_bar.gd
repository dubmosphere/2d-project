extends ProgressBar

@export var health_system: HealthSystem
@export var input: PlayerInput

func _ready() -> void:
	var player_layer = input.player.id + 1
	if player_layer > 1 && get_viewport() is not SubViewport:
		visibility_layer = 0
	else:
		visibility_layer = 1 << player_layer

func _process(_delta: float) -> void:
	value = health_system.health_percentage
