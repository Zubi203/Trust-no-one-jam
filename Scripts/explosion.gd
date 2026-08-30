extends HitboxComponent


func _on_body_entered(_body: Node2D):
	if _body == owner_object:
		return
	if _body is EnemyMovementComponent:
		if owner_object !=  null:
			_body._on_damage_taken(owner_object)
	for child in _body.get_children():
		if child is HealthComponent:
			child.take_damage(damage)
