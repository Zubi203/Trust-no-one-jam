class_name EnemyMovementComponent
extends CharacterBody2D

signal SoundHeard
signal TargetSighted

@export var move_speed: float = 100
@export var speed_multiplier: float = 1
var direction: Vector2

@export var detection_indicator: Sprite2D
@onready var question_mark: Texture2D = preload("uid://bd5nyk8pnn2oy")
@onready var exclamation_point: Texture2D = preload("uid://cje7cn53vgxk2")

@export_category("Raycasts")
@export var line_of_sight: RayCast2D
@export var wall_detector_right: RayCast2D
@export var wall_detector_left: RayCast2D
@export var ledge_end_detector_right: RayCast2D
@export var ledge_end_detector_left: RayCast2D

var target_body: CharacterBody2D = null
var target_point: Vector2

var state_machine: FiniteStateMachine = null
var vision_cone: VisionConeComponent = null

@export var audio: AudioStreamPlayer2D
@export var possession_enter_sound: AudioStream
@export var suspicious_sound: AudioStream
@export var alert_sound: AudioStream

@export var burst: PackedScene = null
@export var damage_effect: GPUParticles2D

func _ready() -> void:
	_enemy_ready.call_deferred()
	GameManager.EmitSound.connect(_on_sound_heard)
	for child in get_children():
		if child is VisionConeComponent:
			child.PlayerDetected.connect(_on_vision_cone_entered)
			vision_cone = child
		if child is FiniteStateMachine:
			state_machine = child
			child.init(self)

func _enemy_ready():
	pass

func direction_input(dir: Vector2):
	direction = dir.normalized()

func action_input(dir: Vector2):
	pass

func jump_input():
	pass

func move(_delta: float):
	pass

func _physics_process(delta: float) -> void:
	if state_machine:
		match state_machine.states.find_key(state_machine.current_state):
			"patrol":
				detection_indicator.hide()
			"suspicious":
				detection_indicator.show()
				detection_indicator.texture = question_mark
			"alert":
				detection_indicator.show()
				detection_indicator.texture = exclamation_point
	move(delta)
	move_and_slide()

func _on_sound_heard(origin_pos: Vector2, sound_range: float):
	var dist = global_position.distance_to(origin_pos)
	if dist > sound_range:
		return
	target_point = origin_pos
	SoundHeard.emit()

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
	TargetSighted.emit()

func _on_damage_taken(damage_source: Node2D):
	if damage_source == null:
		return
	if damage_effect != null:
		damage_effect.emitting = true
	target_body = damage_source
	if not state_machine.states.find_key(state_machine.current_state) == "possessed":
		state_machine.change_state(state_machine.current_state, "alert")

func _set_target(target: Node2D):
	target_body = target
	if target_body != null:
		if not target_body.tree_exiting.is_connected(_target_defeated):
			target_body.tree_exiting.connect(_target_defeated)

func _target_defeated():
	target_body = null

func try_possess_enemy() -> bool:
	if state_machine.states.find_key(state_machine.current_state) == "patrol":
		state_machine.change_state(state_machine.current_state, "possessed")
		play_sound(possession_enter_sound)
		if burst != null:
			var effect = burst.instantiate()
			effect.global_position = global_position
			get_tree().current_scene.add_child(effect)
		return true
	return false

func _exit_tree() -> void:
	if state_machine.states.find_key(state_machine.current_state) == "possessed":
		GameManager.PossessionEnd.emit(global_position)

func play_sound(sound: AudioStream):
	if sound == null:
		return
	if audio == null:
		return
	audio.stream = sound
	audio.play()
