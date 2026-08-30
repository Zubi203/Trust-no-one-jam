class_name HitboxComponent
extends Area2D

@export var damage: int = 3
var owner_object: Node2D
var collider: CollisionShape2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	for child in get_children():
		if child is CollisionShape2D:
			collider = child


func _on_body_entered(_body: Node2D):
	if _body == owner_object:
		return
	if _body.is_in_group("Terrain"):
		_destroy()
	if _body is EnemyMovementComponent:
		if owner_object !=  null:
			_body._on_damage_taken(owner_object)
	for child in _body.get_children():
		if child is HealthComponent:
			child.take_damage(damage)
	_destroy()

func _destroy():
	get_parent().queue_free()

func enable_collider():
	if collider:
		collider.disabled = false

func disable_collider():
	if collider:
		collider.disabled = true
