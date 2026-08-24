class_name ProjectileBase
extends Node2D

@export var active_duration: float = 4
var direction: Vector2 = Vector2.RIGHT
var owner_hurtbox: HurtboxComponent = null
var projectile_data: ProjectileData = null

func set_projectile(owner_box: Area2D, pos: Vector2, target_direction: Vector2, data: ProjectileData = null):
	owner_hurtbox = owner_box
	global_position = pos
	direction = target_direction
	projectile_data = data
	_set_children_components()
	get_tree().create_timer(active_duration).timeout.connect(_destroy)

func _set_children_components():
	for child in get_children():
		if child is Sprite2D and projectile_data != null:
			child.texture = projectile_data.sprite
		if child is HitboxComponent:
			child.owner_object = owner_hurtbox
		if child is ProjectileMovementComponent:
			child.direction = direction

func _destroy():
	queue_free()
