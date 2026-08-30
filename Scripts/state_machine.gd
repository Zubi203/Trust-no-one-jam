class_name FiniteStateMachine
extends Node

@export var states: Dictionary = {}
@export var initial_state: State
var current_state: State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)

func init(body: CharacterBody2D, _animated_sprite: AnimatedSprite2D = null, _animation_player: AnimationPlayer = null) -> void:
	for key in states.keys():
		if states[key] is State:
			states[key].character_body = body
			#states[key].animated_sprite = animated_sprite
			#states[key].animation_player = animation_player
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func change_state(source_state: State, new_state_name: String) -> void:
	if source_state != current_state:
		#print("desired state already active")
		return
	var new_state: State = states.get(new_state_name)
	if !new_state:
		#print("desired state does not exist")
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state

func force_change_state(new_state_name: String) -> void:
	var new_state: State = states.get(new_state_name)
	if !new_state:
		pass
	if new_state == current_state:
		pass
	
	if current_state:
		current_state.exit.call_deferred()
	
	new_state.enter()
	current_state = new_state
