class_name EnemyHumanVisuals
extends Node2D

# Just rotates upper to look at a specific point. When possessed this should be mouse

var _posessed := true
@onready var _upper_body = $Upper

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _posessed:
		_upper_body.look_at(-get_global_mouse_position())
