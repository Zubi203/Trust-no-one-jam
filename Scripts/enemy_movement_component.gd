class_name EnemyMovementComponent
extends CharacterBody2D

@export var move_speed: float = 100
var direction: Vector2

@export var detection_indicator: Sprite2D
@export var question_mark: Texture2D
@export var exclamation_point: Texture2D

@export var line_of_sight: RayCast2D
var target_body: CharacterBody2D = null
var target_point: Vector2

func _ready() -> void:
	GameManager.EmitSound.connect(_on_sound_heard)
	for child in get_children():
		if child is VisionConeComponent:
			child.PlayerDetected.connect(_on_vision_cone_entered)
			

func _enemy_ready():
	pass

func direction_input(dir: Vector2):
	direction = dir

func action_input(dir: Vector2):
	pass

func jump_input():
	pass

func move(delta: float):
	pass

func _physics_process(delta: float) -> void:
	move(delta)
	move_and_slide()

func _on_sound_heard(origin_pos: Vector2, sound_range: float):
	var dist = global_position.distance_to(origin_pos)
	if dist > sound_range:
		return
	target_point = origin_pos
	
	if detection_indicator:
		detection_indicator.show()
		detection_indicator.texture = question_mark
		await get_tree().create_timer(1).timeout
		detection_indicator.hide()

func _has_line_of_sight() -> bool:
	if line_of_sight == null:
		return true
	if target_body == null:
		return false
	line_of_sight.target_position = to_local(target_body.global_position)
	return not line_of_sight.is_colliding()

func _on_vision_cone_entered():
	_set_target(get_tree().get_first_node_in_group("Player"))
	if not _has_line_of_sight():
		return
	if detection_indicator:
		detection_indicator.show()
		detection_indicator.texture = exclamation_point
		await get_tree().create_timer(1).timeout
		detection_indicator.hide()

func _on_damage_taken():
	pass

func _set_target(target: Node2D):
	target_body = target
	if target_body != null:
		if not target_body.tree_exiting.is_connected(_target_defeated):
			target_body.tree_exiting.connect(_target_defeated)

func _target_defeated():
	target_body = null
