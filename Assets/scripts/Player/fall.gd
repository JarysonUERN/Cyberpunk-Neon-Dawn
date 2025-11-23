extends State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	# 1. Aplica Gravidade
	player.velocity.y += gravity * delta
	
	# 2. Lógica de Chute Aéreo
	# (Verificamos se a variável existe para não crashar se estiver vazia)
	if jump_kick_state and Input.is_action_just_pressed(kick):
		return jump_kick_state
	
	# 3. Movimento no Ar
	var movement = Input.get_axis(left, right) * move_speed
	
	# --- CORREÇÃO AQUI (O Erro do Sprite) ---
	# Pegamos o nó visual pelo nome exato que está na sua cena
	var visual = player.get_node("Sprite")
	
	if movement < 0:
		visual.flip_h = true
	elif movement > 0:
		visual.flip_h = false
	
	# 4. Aplica Velocidade
	player.velocity.x = movement
	player.move_and_slide()
	
	# 5. Aterrissagem (Tocou no chão)
	if player.is_on_floor():
		
		# ATENÇÃO AO SOM:
		# Se o nó de som estiver dentro do Estado Fall, use o código abaixo.
		if has_node("AudioStreamPlayer"):
			$AudioStreamPlayer.play()
		# Se o nó de som estiver no PLAYER, use esta linha (remova o #):
		# player.get_node("AudioStreamPlayer").play()

		if movement != 0:
			return walk_state
		return idle_state
		
	return null
