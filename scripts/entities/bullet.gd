class_name Bullet
extends Area2D

const SPEED: float = 2000.0
const DAMAGE: float = 10.0
const LIVE_TIME = 5.0

var actor: Entity
var direction: Vector2 = Vector2(0.0, 0.0)

var damage: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if actor:
		var weapon: RangedWeapon = actor.get_node("Components/RangedWeapon")
		damage = weapon.damage
	$ShotSound.play()
	await get_tree().create_timer(LIVE_TIME).timeout
	queue_free.call_deferred()

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
	print(target_actor.position)
	print(global_position)
	var health_system: HealthSystem = target_actor.get_node("Components/HealthSystem")
	
	print(body)
	health_system.apply_dammage(damage)
	
	if health_system.health <= 0:
		target_actor.queue_free.call_deferred()
