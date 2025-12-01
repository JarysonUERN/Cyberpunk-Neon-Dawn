class_name EnemyStateMachine
extends Node2D 

# MUDANÇA 1: Agora a variável armazena um EnemyState
var current_state: EnemyState
# MUDANÇA 2: O array lista EnemyStates
var states: Array[EnemyState] = []

var can_change_state: bool = true

# MUDANÇA 3: O estado inicial deve ser um EnemyState
@export var starting_state: EnemyState

func init(enemy: Node) -> void:
	for child in get_children():
		# MUDANÇA 4: Verifica se o filho é um EnemyState
		if child is EnemyState: 
			states.append(child)
			child.player = enemy 
			
	if starting_state:
		change_state(starting_state)

func process_physics(delta: float) -> void:
	if current_state:
		# A variável new_state infere o tipo automaticamente do retorno
		var new_state = current_state.process_physics(delta)
		if new_state:
			change_state(new_state)

# MUDANÇA 5: A função aceita EnemyState
func change_state(new_state: EnemyState) -> void:
	if not can_change_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func can_change_state_to_false() -> void:
	can_change_state = false

func can_change_state_to_true() -> void:
	can_change_state = true
