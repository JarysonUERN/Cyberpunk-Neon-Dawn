extends EnemyState

@export var air_speed: float = 150.0

func enter() -> void:
	super()
	_play_animation("Fall")

# --- CORREÇÃO CRÍTICA AQUI ---
# Retorna EnemyState para não dar erro na Máquina
func process_physics(delta: float) -> EnemyState:
	# 1. Aplica Gravidade
	player.velocity.y += gravity * delta
	
	# 2. Movimento Aéreo (IA tenta cair em cima do alvo)
	var target = get_target() # Usa o helper criado no pai
	if target:
		var dir_x = sign(target.global_position.x - player.global_position.x)
		
		# Movemos suavemente no ar
		player.velocity.x = move_toward(player.velocity.x, dir_x * air_speed, 10.0)
		
		_flip_sprite(dir_x)

		# 3. Decisão de CHUTE AÉREO
		# Se estiver perto e tiver o estado configurado
		var dist = player.global_position.distance_to(target.global_position)
		if dist < 80 and jump_kick_state and not player.is_on_floor():
			return jump_kick_state
	
	player.move_and_slide()
	
	# 4. Aterrissagem (Tocou no chão)
	if player.is_on_floor():
		if has_node("AudioStreamPlayer"):
			$AudioStreamPlayer.play()
		
		# Zera a velocidade X ao pousar para não deslizar
		player.velocity.x = 0
		return idle_state
		
	return null

# --- FUNÇÕES AUXILIARES ---
func _flip_sprite(dir_x: float):
	if dir_x != 0:
		if player.has_node("Sprite"):
			player.get_node("Sprite").flip_h = (dir_x < 0)
		elif player.has_node("AnimatedSprite2D"):
			player.get_node("AnimatedSprite2D").flip_h = (dir_x < 0)

func _play_animation(anim_name: String):
	if player.has_node("Player"): 
		player.get_node("Player").play(anim_name)
	elif player.has_node("Sprite"): 
		player.get_node("Sprite").play(anim_name)
