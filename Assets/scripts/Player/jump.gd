extends State

func enter() -> void:
	super()
	# Aplica a força do pulo para cima (negativo no Y é pra cima)
	player.velocity.y = -jump_force

func process_physics(delta: float) -> State:
	# 1. Controle Aéreo: Permite mover um pouco enquanto pula (Opcional)
	var movement = Input.get_axis(left, right) * move_speed
	player.velocity.x = movement
	
	# Virar o sprite no ar
	if movement != 0:
		if player.has_node("Sprite"):
			player.get_node("Sprite").flip_h = (movement < 0)

	# 2. Gravidade
	player.velocity.y += gravity * delta
	player.move_and_slide()
	
	# 3. Transição: Chute Aéreo (Jump Kick)
	# Verifica se apertou chute E se a variável jump_kick_state foi conectada
	if Input.is_action_just_pressed(kick) and jump_kick_state:
		return jump_kick_state

	# 4. Transição: Começou a cair? Vai para o estado Fall
	if player.velocity.y > 0:
		return fall_state
	
	# 5. Transição de segurança: Se bater a cabeça e tocar no chão
	if player.is_on_floor():
		if movement == 0:
			return idle_state
		else:
			return walk_state
			
	return null
