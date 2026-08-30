class_name Switch
extends Area2D

signal Activated

@export var connected_doors: Array[LockedDoor] = []
@export var guard_activation_range: float = 150

@export var switch_textures: Array[Texture2D] = []
var activated: bool = false

func _ready() -> void:
	for door in connected_doors:
		Activated.connect(door.open_door)
	activated = false

func _process(delta: float) -> void:
	$Sprite2D.texture = switch_textures[int(activated)]

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Enemy"):
		return
	if activated:
		return
	if body is EnemyMovementComponent:
		var state_machine: FiniteStateMachine = body.state_machine
		if state_machine.states.find_key(state_machine.current_state) == "possessed":
			Activated.emit()
			activated = true
			$SwitchAudio.play()
			$SoundEmitterComponent.emit_sound(guard_activation_range)
