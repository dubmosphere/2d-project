class_name Bullet
extends Area2D

const SPEED: float = 1000.0
const DAMAGE: float = 10.0
const LIVE_TIME = 10.0

var actor: Entity
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
	if body is Player && Main.godmode:
		return
	
	queue_free()
	if body is not Entity:
		return
	
	var target_actor: Entity = body
	var health_system: HealthSystem = target_actor.get_node("Components/HealthSystem")
	var weapon: RangedWeapon = actor.get_node("Components/RangedWeapon")
	
	health_system.apply_dammage(weapon.damage)
	
	if health_system.health <= 0:
		target_actor.queue_free()
