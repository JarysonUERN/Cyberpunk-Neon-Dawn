extends Area2D

# Referências
@onready var state_machine: Node = $"../.."
@onready var hurt_state: Node = $".."
@onready var block_state: Node = $"../../Block"
@onready var particles: CPUParticles2D = $"../../../Hurt Particles"
@onready var player: CharacterBody2D = $"../../.."
@onready var camera: Camera2D = $"../../../../Camera"
@onready var health_node: Node = $"../../../Health"
@onready var block_area: Area2D = $"../../Block/BlockBox"

# Configuração: Jogador toma 40% do dano (redução de 60%)
var block_damage_factor: float = 0.4

func on_area_entered(hitbox) -> void:
	if hitbox == null:
		return

	# Ignora hitbox do próprio dono
	if hitbox.owner == player:
		return

	var damage_amount = 0
	if "damage" in hitbox:
		damage_amount = hitbox.damage
	
	# --- LÓGICA DE DEFESA ---
	
	# 1. Verifica se a State Machine diz que o estado atual é o Block
	var current_state_node = state_machine.current_state if "current_state" in state_machine else null
	var is_in_block_state = (current_state_node == block_state)
	
	# 2. Verifica a Direção (Nova Lógica mais estável)
	var blocked_direction = false
	if is_in_block_state:
		# Pega a direção do ataque em relação ao player
		# Se (ataque.x - player.x) for positivo, o ataque vem da direita.
		var attack_vector_x = (hitbox.global_position.x - global_position.x)
		
		# Verifica para onde o player está olhando
		# flip_h = false geralmente significa olhando para a direita
		var is_facing_right = not player.get_node("Sprite").flip_h
		
		if is_facing_right:
			# Se olho para direita, defendo ataques que vêm da direita (x > 0)
			if attack_vector_x > 0:
				blocked_direction = true
		else:
			# Se olho para esquerda, defendo ataques que vêm da esquerda (x < 0)
			if attack_vector_x < 0:
				blocked_direction = true

	# Condição Final: Precisa estar no estado E estar defendendo o lado certo
	if is_in_block_state and blocked_direction:
		# --- CENÁRIO: BLOQUEIO BEM SUCEDIDO ---
		print("Defendeu! Dano reduzido.")
		
		var reduced_damage = int(damage_amount * block_damage_factor)
		
		if health_node:
			health_node.deal_damage(reduced_damage)
			
		var audio = $"../../Block/BlockBox/AudioStreamPlayer"
		if audio: 
			audio.play()
			
	else:
		# --- CENÁRIO: LEVOU DANO (Hurt) ---
		print("Levou Dano Cheio!")
		
		# 1. Partículas
		if particles:
			var direction = (hitbox.global_position - global_position).normalized()
			particles.gravity = Vector2(abs(particles.gravity.x), particles.gravity.y) * -direction.x
			particles.emitting = true
		
		# 2. Empurrão (Knockback)
		var diff_vector = global_position - hitbox.global_position
		diff_vector.y = 0 
		var push_dir = diff_vector.normalized()
		player.velocity = push_dir * 400 
		
		# 3. Camera Shake
		if camera and camera.has_method("shake"):
			camera.shake_str = 1.0 
			
		# 4. Dano Total
		if health_node:
			health_node.deal_damage(damage_amount)
		
		# 5. Muda para o estado Hurt
		if player.has_method("change_state"):
			player.change_state(hurt_state)
