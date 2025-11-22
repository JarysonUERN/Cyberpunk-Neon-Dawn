class_name Player
extends CharacterBody2D


# Referência para o nó que segura os estados
@onready var state_machine = $"State Machine"
@onready var animated_sprite = $AnimatedSprite2D

# Estado inicial (Arraste o nó Idle para cá no Inspector)
@export var starting_state: State

# Variável para saber qual estado está rodando agora
var current_state: State

func _ready():
	# Inicializa os estados
	# Passa a referência deste Player para todos os filhos do StateMachine
	for child in state_machine.get_children():
		if child is State:
			child.player = self
	
	# Inicia o primeiro estado
	if starting_state:
		change_state(starting_state)
	else:
		print("ERRO: Starting State não definido no Player!")

func _physics_process(delta):
	# --- DEBUG ---
	if current_state == null:
		print("SOCORRO: Eu não tenho um Estado Atual! (Verifique o Starting State)")
	else:
		# Isso vai imprimir o nome do estado atual o tempo todo (ex: Idle, Walk)
		# Se ficar preso em "Idle" enquanto você aperta A, o problema é no Input ou na Conexão.
		print("Estado Atual: ", current_state.name) 
	# -------------

	if current_state:
		var next_state = current_state.process_physics(delta)
		if next_state:
			change_state(next_state)

func _input(event):
	# Pergunta para o estado atual o que fazer com o input (pulo, soco...)
	if current_state:
		var next_state = current_state.process_input(event)
		if next_state:
			change_state(next_state)

func change_state(new_state: State):
	# 1. Sai do antigo
	if current_state:
		current_state.exit()
	
	# 2. Atualiza
	current_state = new_state
	
	# 3. Entra no novo
	current_state.enter()
