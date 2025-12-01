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
	# Isso garante que as conexões existam mesmo se o Inspector estiver vazio
	if state_machine:
		# 1. Pega os nós filhos da State Machine pelos nomes exatos da cena
		var idle_node = state_machine.get_node_or_null("Idle")
		var walk_node = state_machine.get_node_or_null("Walk")
		var punch_node = state_machine.get_node_or_null("Punch")
		var block_node = state_machine.get_node_or_null("Block")
		var kick_node = state_machine.get_node_or_null("Kick") # Se tiver
		var jump_node = state_machine.get_node_or_null("Jump")
		var fall_node = state_machine.get_node_or_null("Fall")
		
		# 2. Define o Estado Inicial (Resolve o congelamento inicial)
		if idle_node:
			state_machine.starting_state = idle_node
		else:
			push_error("ERRO CRITICO: Nó 'Idle' não encontrado dentro da State Machine!")

		# 3. Conecta as transições do IDLE (Resolve ela não perseguir)
		if idle_node:
			idle_node.walk_state = walk_node
			# Se quiser que ela pule/caia do idle:
			idle_node.fall_state = fall_node 

		# 4. Conecta as transições do WALK (Resolve ela travar na frente do player)
		if walk_node:
			walk_node.idle_state = idle_node   # Se o player sumir
			walk_node.punch_state = punch_node # Se chegar perto -> SOCO
			walk_node.block_state = block_node # Se o player atacar -> DEFESA
			# walk_node.kick_state = kick_node # Se tiver chute
			
		# 5. Conecta o retorno do PUNCH (Evita loop ou travamento após soco)
		if punch_node:
			punch_node.return_state = idle_node # Volta para Idle após bater

		# 6. Conecta o retorno do BLOCK
		if block_node:
			block_node.idle_state = idle_node

	# --- FIM DA CORREÇÃO ---

	# Inicializa a máquina normalmente
	if state_machine:
		state_machine.init(self)

func _physics_process(delta):
	if state_machine:
		state_machine.process_physics(delta)

func change_state(new_state: EnemyState) -> void:
	if state_machine:
		state_machine.change_state(new_state)
