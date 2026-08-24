class_name Clone
extends StaticBody2D

var collider: CollisionShape2D
var is_active: bool = false
var shoot_component: ShootProjectileComponent = null
var shoot_direction: Vector2 = Vector2.RIGHT
@export var shoot_cooldown_timer: Timer = null
var projectile_type: GameManager.ProjectileTypes
@export var projectile_cooldowns: Dictionary[GameManager.ProjectileTypes, float] = {
	GameManager.ProjectileTypes.PIERCE: 0.5,
	GameManager.ProjectileTypes.BOUNCE: 0.4,
	GameManager.ProjectileTypes.EXPLODE: 0.7
}

func set_clone(sprite: Texture2D, shoot_dir: Vector2, type: GameManager.ProjectileTypes):
	for child in get_children():
		if child is Sprite2D:
			child.texture = sprite
		if child is ShootProjectileComponent:
			shoot_component = child
		if child is CollisionShape2D:
			collider = child
	shoot_direction = shoot_dir
	projectile_type = type
	GameManager.BeginEscape.connect(_on_escape_begin)
	_disable_collider.call_deferred()

func _on_escape_begin():
	is_active = true
	_enable_collider.call_deferred()

func _process(_delta: float) -> void:
	if is_active:
		_try_shoot_projectile()

func _try_shoot_projectile():
	if shoot_component == null:
		return
	if shoot_cooldown_timer == null:
		return
	
	if shoot_cooldown_timer.time_left:
		return
	shoot_cooldown_timer.start(projectile_cooldowns[projectile_type])
	shoot_component.shoot(projectile_type, shoot_direction)

func _enable_collider():
	if collider:
		collider.disabled = false

func _disable_collider():
	if collider:
		collider.disabled = true
