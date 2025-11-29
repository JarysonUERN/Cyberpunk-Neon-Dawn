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

	var damage_amount = 0
	if "damage" in hitbox:
		damage_amount = hitbox.damage
	
	# 2. Partículas
	if particles:
		var direction = (hitbox.global_position - global_position).normalized()
		particles.gravity = particles.gravity.length() * direction
		particles.emitting = true
	
	var diff_vector = global_position - hitbox.global_position
	diff_vector.y = 0 
	
	var push_dir = diff_vector.normalized()
	

	player.velocity = push_dir * 400 
	
	if camera and camera.has_method("shake"):
		camera.shake_str = 1.0 
	
	var is_blocking = (player.current_state == block_state)
		
	if not is_blocking:
		if health_node:
			health_node.deal_damage(damage_amount)
		player.change_state(hurt_state)
	else:
		var audio = $"../../Block/AudioStreamPlayer"
		if audio: audio.play()

func engine_slow():
	pass
