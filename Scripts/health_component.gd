class_name HealthComponent
extends Node2D

signal HealthDepleted
signal DamageTaken (amount: int)

@export var max_health: int = 20
var health: int:
	set(value):
		health = value
		if health_bar:
			health_bar.value = health
		if health <= 0:
			HealthDepleted.emit()
			defeated()
@export var health_bar: Range = null

func _ready():
	_set_max_health.call_deferred()

func _set_max_health():
	health = max_health
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = max_health

func take_damage(amount: int):
	health -= amount
	DamageTaken.emit(amount)

func defeated():
	owner.queue_free.call_deferred()
