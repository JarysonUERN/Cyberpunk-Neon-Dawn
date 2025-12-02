extends EnemyState

@export var chase_speed: float = 80.0
@export var aggression: float = 0.5 
@export var jump_chance: float = 0.02 
@export var sprite_faces_left: bool = false 

@export var jump_cooldown_time: float = 3.0 
var current_jump_timer: float = 0.0

# --- NOVO CÓDIGO (1/3) ---
# Tempo de espera entre ataques (2 segundos conforme solicitado)
@export var attack_cooldown: float = 2.0
var current_attack_timer: float = 0.0
# -------------------------

func enter() -> void:
	super()
	
	var visual_node = _get_visual_node()
	if visual_node and (visual_node is AnimatedSprite2D):
		if visual_node.animation != "Walk":
			visual_node.play("Walk")
	elif player.has_node("Player"): 
		player.get_node("Player").play("Walk")

func process_physics(delta: float) -> EnemyState:
	player.velocity.y += gravity * delta
	
	if current_jump_timer > 0:
		current_jump_timer -= delta
		
	# --- NOVO CÓDIGO (2/3) ---
	# Diminui o tempo de recarga do soco
	if current_attack_timer > 0:
		current_attack_timer -= delta
	# -------------------------
	
	var target = player.target
	if not target:
		return idle_state 
	
	var dist = player.global_position.distance_to(target.global_position)
	var dir_x = sign(target.global_position.x - player.global_position.x)
	
	if target.get("current_state") and target.current_state.name in ["Punch", "Kick", "Jump Kick"]:
		if dist < 120:
			if block_state:
				return block_state

	if current_jump_timer <= 0:
		if (not target.is_on_floor()) or (randf() < jump_chance):
			if jump_state:
				current_jump_timer = jump_cooldown_time 
				return jump_state

	var attack_range = player.get("attack_range")
	if attack_range == null: attack_range = 40.0
	
	# --- CÓDIGO ALTERADO (3/3) ---
	if dist <= (attack_range - 10):
		# Só ataca se o timer zerou
		if current_attack_timer <= 0:
			player.velocity.x = 0
			current_attack_timer = attack_cooldown # Reseta o timer para 2s
			return punch_state
		else:
			# Se estiver perto mas em recarga (cooldown), o inimigo para e espera
			player.velocity.x = 0
	# -----------------------------
	else:
		player.velocity.x = dir_x * chase_speed

		if dir_x != 0 and abs(player.global_position.x - target.global_position.x) > 20:
			var facing_direction = 1 
			
			if dir_x < 0:
				facing_direction = -1
				
			if sprite_faces_left:
				facing_direction *= -1
			
			var visual_node = _get_visual_node()
			if visual_node:
				visual_node.scale.x = abs(visual_node.scale.x) * facing_direction
			
			if player.has_node("State Machine"):
				var sm = player.get_node("State Machine")
				if "scale" in sm:
					sm.scale.x = abs(sm.scale.x) * facing_direction

	player.move_and_slide()
	return null

# Função auxiliar para achar o sprite independente do nome
func _get_visual_node() -> Node2D:
	if player.has_node("AnimatedSprite2D"):
		return player.get_node("AnimatedSprite2D")
	elif player.has_node("Sprite"):
		return player.get_node("Sprite")
	elif player.has_node("Sprite2D"):
		return player.get_node("Sprite2D")
	return null
