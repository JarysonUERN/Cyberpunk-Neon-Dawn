extends Area2D

@onready var state_machine: Node = $"../.." 
@onready var hurt_state: Node = $".."
@onready var block_state: Node = $"../../Block" 
@onready var particles: CPUParticles2D = $"../../../Hurt Particles"
@onready var player: CharacterBody2D = $"../../.." 
@onready var camera: Camera2D = $"../../../../Camera"
@onready var health_node: Node = $"../../../Health"

# --- NOVO: Referência à sua caixa de colisão de defesa ---
# Ajuste o caminho se o nó BlockBox não for irmão imediato do HurtBox
@onready var block_area: Area2D = $"../BlockBox" 

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
	
	# 1. Verifica Estado (Se está segurando o botão)
	var is_in_block_state = (player.current_state == block_state)
	
	# 2. Verifica Geometria (Se o ataque bateu na BlockBox)
	var hit_shield = false
	if block_area and hitbox is Area2D:
		# Verifica fisicamente se a hitbox do ataque encostou na BlockBox
		hit_shield = block_area.overlaps_area(hitbox)
	
	# Condição Final: Precisa estar no estado E ter batido no escudo
	if is_in_block_state and hit_shield:
		# --- CENÁRIO: BLOQUEIO BEM SUCEDIDO ---
		# Não aplica knockback (player.velocity), então ele não desliza.
		
		var reduced_damage = int(damage_amount * block_damage_factor)
		
		if health_node:
			health_node.deal_damage(reduced_damage)
			
		var audio = $"../../Block/AudioStreamPlayer"
		if audio: 
			audio.play()
			
	else:
		# --- CENÁRIO: LEVOU DANO (Não defendeu ou defendeu de costas) ---
		
		# 1. Partículas (Só aparecem se levar dano cheio)
		if particles:
			var direction = (hitbox.global_position - global_position).normalized()
			particles.gravity = particles.gravity.length() * direction
			particles.emitting = true
		
		# 2. Empurrão (Knockback) - Só acontece aqui
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
		
		# 5. Entra no estado de Hurt
		player.change_state(hurt_state)

func engine_slow():
	pass
