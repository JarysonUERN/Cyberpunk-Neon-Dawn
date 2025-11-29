extends Area2D

@onready var state_machine: Node = $"../.." 
@onready var hurt_state: Node = $".."
@onready var block_state: Node = $"../../Block"
@onready var particles: CPUParticles2D = $"../../../Hurt Particles"
@onready var player: CharacterBody2D = $"../../.."
@onready var camera: Camera2D = $"../../../../Camera"
@onready var health_node: Node = $"../../../Health"

func on_area_entered(hitbox) -> void:
	if hitbox == null:
		return
	
	# 1. Dano
	var damage_amount = 0
	if "damage" in hitbox:
		damage_amount = hitbox.damage
	
	# 2. Partículas
	if particles:
		var direction = (hitbox.global_position - global_position).normalized()
		particles.gravity = particles.gravity.length() * direction
		particles.emitting = true
	
	# 3. CORREÇÃO FÍSICA (O Segredo)
	# Calculamos a direção, mas ZERAMOS o eixo Y para ele não voar
	var diff_vector = global_position - hitbox.global_position
	diff_vector.y = 0 # Força o vetor a ser reto horizontalmente
	
	var push_dir = diff_vector.normalized()
	
	# Aplica uma velocidade horizontal forte
	player.velocity = push_dir * 400 
	
	# 4. Câmera
	if camera and camera.has_method("shake"):
		camera.shake_str = 1.0 
	
	# 5. Troca de Estado
	var is_blocking = (state_machine.current_state == block_state)
		
	if not is_blocking:
		if health_node:
			health_node.deal_damage(damage_amount)
		
		state_machine.can_change_state_to_true()
		state_machine.change_state(hurt_state)
	else:
		var audio = $"../../Block/AudioStreamPlayer"
		if audio: audio.play()

func engine_slow():
	pass
