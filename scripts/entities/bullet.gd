class_name Bullet
extends Area2D

const SPEED: float = 1000.0
const DAMAGE: float = 10.0
const LIVE_TIME = 10.0

var entity: Entity
var direction: Vector2 = Vector2(0.0, 0.0)

var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ShotSound.play()

func _process(delta: float) -> void:
	timer += delta
	if timer >= LIVE_TIME:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var velocity: Vector2 = direction * SPEED
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	# Do not do anything if colliding with shooting player
	if entity == (body as Entity):
		return
	
	if body is Player && Main.godmode:
		return
	
	queue_free()
	if body is not Entity:
		return
	
	var entity: Entity = body as Entity
	var health_system = entity.get_node("Components/HealthSystem") as HealthSystem
	health_system.health -= DAMAGE
	if health_system.health <= 0:
		entity.queue_free()
