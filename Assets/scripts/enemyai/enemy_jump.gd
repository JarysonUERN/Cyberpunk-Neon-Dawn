extends State

# IA tenta se mover no ar em direção ao alvo
var air_speed: float = 150.0

func enter() -> void:
	super()
	# Aplica força de pulo
	player.velocity.y = -jump_force
	
	# Toca animação
	if player.has_node("Sprite"):
		player.get_node("Sprite").play("Jump")

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	
	var target = player.target
	
	if target:
		# IA se move no ar em direção ao jogador
		var dir_x = sign(target.global_position.x - player.global_position.x)
		player.velocity.x = dir_x * air_speed
		
		# --- DECISÃO DE JUMP KICK ---
		# Se estiver caindo (velocity.y > 0) e perto do alvo, CHUTA!
		var dist = player.global_position.distance_to(target.global_position)
		if player.velocity.y > -100 and dist < 100: # Ajuste a distância conforme necessário
			if jump_kick_state:
				return jump_kick_state
	
	player.move_and_slide()
	
	# Transição para Queda
	if player.velocity.y > 0:
		return fall_state
		
	if player.is_on_floor():
		return idle_state
		
	return null
