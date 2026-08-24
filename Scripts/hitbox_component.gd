class_name HitboxComponent
extends Area2D

var owner_object: Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _on_area_entered(area: Area2D):
	if area == owner_object:
		return
	if area == _try_get_hurtbox_sibling():
		return
	if area is HurtboxComponent:
		area.take_damage()
		_destroy()

func _on_body_entered(_body: Node2D):
	if _body.is_in_group("Terrain"):
		_destroy()

func _destroy():
	get_parent().queue_free()

func _try_get_hurtbox_sibling() -> HurtboxComponent:
	for child in get_parent().get_children():
		if child is HurtboxComponent:
			return child
	return null
