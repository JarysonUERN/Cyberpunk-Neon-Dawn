extends EnemyState

# --- VARIÁVEIS DE CONFIGURAÇÃO ---
@export var chase_speed: float = 80.0
@export var aggression: float = 0.5 
@export var jump_chance: float = 0.02 

# Ajuste de direção da arte
@export var sprite_faces_left: bool = false 

func enter() -> void:
	super()
	var target = player.target
	if target:
		var dir_x = sign(target.global_position.x - player.global_position.x)
		if dir_x != 0:
			var visual_node = _get_visual_node()
			if visual_node:
				if visual_node.scale.x > 0 and dir_x < 0:
					visual_node.scale.x *= -1
				elif visual_node.scale.x < 0 and dir_x > 0:
					visual_node.scale.x *= -1

func process_physics(delta: float) -> EnemyState:
	player.velocity.y += gravity * delta
	
	var target = player.target
	if not target:
		return idle_state 
	
	var dist = player.global_position.distance_to(target.global_position)
	var dir_x = sign(target.global_position.x - player.global_position.x)
	
	# --- 1. DECISÃO DE DEFESA ---
	if target.get("current_state") and target.current_state.name in ["Punch", "Kick", "Jump Kick"]:
		if dist < 120: 
			return block_state

	# --- 2. DECISÃO DE PULO ---
	if (not target.is_on_floor()) or (randf() < jump_chance):
		if jump_state:
			return jump_state

	# --- 3. DECISÃO DE ATAQUE E MOVIMENTO ---
	var attack_range = player.get("attack_range")
	if attack_range == null: attack_range = 40.0
	
	if dist <= (attack_range - 10):
		player.velocity.x = 0
		return punch_state
	else:
		# MOVIMENTO
		player.velocity.x = dir_x * chase_speed
		
		# --- CORREÇÃO DO GIRO (Sprite + Hitboxes) ---
		if dir_x != 0 and abs(player.global_position.x - target.global_position.x) > 20:
			var facing_direction = 1 # 1 é direita (padrão)
			
			if dir_x < 0:
				facing_direction = -1
				
			if sprite_faces_left:
				facing_direction *= -1
			
			# 1. Gira o SPRITE (Visual)
			var visual_node = _get_visual_node()
			if visual_node:
				visual_node.scale.x = abs(visual_node.scale.x) * facing_direction
			
			# 2. Gira a STATE MACHINE (Onde estão os golpes: Punch, Kick, Block)
			# Nota: A "State Machine" na cena precisa ser do tipo Node2D para ter scale.
			if player.has_node("State Machine"):
				var sm = player.get_node("State Machine")
				# Só aplica se o nó tiver a propriedade scale (for Node2D)
				if "scale" in sm:
					sm.scale.x = abs(sm.scale.x) * facing_direction

	player.move_and_slide()
	return null

func _get_visual_node() -> Node2D:
	if player.has_node("AnimatedSprite2D"):
		return player.get_node("AnimatedSprite2D")
	elif player.has_node("Sprite"):
		return player.get_node("Sprite")
	elif player.has_node("Sprite2D"):
		return player.get_node("Sprite2D")
	return null
