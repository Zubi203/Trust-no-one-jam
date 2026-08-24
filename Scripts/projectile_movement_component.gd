class_name ProjectileMovementComponent
extends Node2D

@export var speed: float = 700
var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	_move(delta)

func _move(delta: float):
	get_parent().translate(speed * direction.normalized() * delta)
	rotation = direction.angle()
