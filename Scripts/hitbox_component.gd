class_name HitboxComponent
extends Area2D

@export var damage: int = 3
var owner_object: Node2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node2D):
	if _body == owner_object:
		return
	if _body.is_in_group("Terrain"):
		_destroy()
	for child in _body.get_children():
		if child is HealthComponent:
			child.take_damage(damage)

func _destroy():
	get_parent().queue_free()
