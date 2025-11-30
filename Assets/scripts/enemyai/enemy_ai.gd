class_name EnemyAI
extends CharacterBody2D

@onready var state_machine = $"State Machine"
@onready var animated_sprite = $AnimatedSprite2D

@export var starting_state: State
@export var target: CharacterBody2D # Mudado para CharacterBody2D para aceitar o Player

var current_state: State

func _ready():
	# Inicializa os estados
	for child in state_machine.get_children():
		if child is State:
			child.player = self

	if starting_state:
		change_state(starting_state)
	else:
		push_error("ERRO: Starting State não definido na IA!")

func _physics_process(delta):
	if current_state:
		var s = current_state.process_physics(delta)
		if s:
			change_state(s)


func change_state(new_state: State):
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
