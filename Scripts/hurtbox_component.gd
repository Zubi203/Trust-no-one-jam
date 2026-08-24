class_name HurtboxComponent
extends Area2D

var health: int = 1:
	set(value):
		health = value
		if health <= 0:
			get_parent().queue_free()

func take_damage(amount: int = 1):
	health -= amount
