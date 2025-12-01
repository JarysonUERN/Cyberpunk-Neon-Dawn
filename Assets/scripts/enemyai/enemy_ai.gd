class_name EnemyAI
extends CharacterBody2D

# Referência à máquina de estados da IA
@onready var state_machine: EnemyStateMachine = $"State Machine"
@onready var animated_sprite = $Player # Ou $Sprite, dependendo da sua cena

@export var target: CharacterBody2D 

var current_state: EnemyState:
	get:
		if state_machine:
			return state_machine.current_state
		return null

func _ready():
	# --- CORREÇÃO VIA CÓDIGO (HARDCODED) ---
	if state_machine:
		var idle_node = state_machine.get_node_or_null("Idle")
		var walk_node = state_machine.get_node_or_null("Walk")
		var punch_node = state_machine.get_node_or_null("Punch")
		var block_node = state_machine.get_node_or_null("Block")
		var kick_node = state_machine.get_node_or_null("Kick")
		var jump_node = state_machine.get_node_or_null("Jump")
		var fall_node = state_machine.get_node_or_null("Fall")
		var jump_kick_node = state_machine.get_node_or_null("Jump Kick")
		
		# Define o Estado Inicial
		if idle_node:
			state_machine.starting_state = idle_node

		# --- CONEXÕES DO IDLE ---
		if idle_node:
			idle_node.walk_state = walk_node
			idle_node.fall_state = fall_node 
			idle_node.jump_state = jump_node

		# --- CONEXÕES DO WALK (PERSEGUIÇÃO) ---
		if walk_node:
			walk_node.idle_state = idle_node
			walk_node.punch_state = punch_node
			walk_node.block_state = block_node
			walk_node.jump_state = jump_node 
			walk_node.fall_state = fall_node

		# Conexões de Combate
		if punch_node: punch_node.return_state = idle_node
		if block_node: block_node.idle_state = idle_node

		# Conexões Aéreas (Para o Jump Kick funcionar)
		if jump_node:
			jump_node.fall_state = fall_node
			jump_node.jump_kick_state = jump_kick_node 
			
		if fall_node:
			fall_node.idle_state = idle_node
			fall_node.jump_kick_state = jump_kick_node 

		# Configuração do Jump Kick Hitbox
		if jump_kick_node:
			jump_kick_node.idle_state = idle_node 
			jump_kick_node.fall_state = fall_node 
			if jump_kick_node.hitbox == null:
				var box = jump_kick_node.find_child("Jump Kick")
				if not box: box = jump_kick_node.find_child("Hitbox")
				if box and box is Area2D:
					jump_kick_node.hitbox = box

	# Inicializa a máquina
	if state_machine:
		state_machine.init(self)

func _physics_process(delta):
	if state_machine:
		state_machine.process_physics(delta)

func change_state(new_state: EnemyState) -> void:
	if state_machine:
		state_machine.change_state(new_state)
