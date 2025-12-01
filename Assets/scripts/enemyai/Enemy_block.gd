extends State

var block_timer: float = 0.0
var min_block_time: float = 0.5 # Tempo mínimo que ela segura o bloqueio

func enter() -> void:
	super()
	player.velocity.x = 0
	block_timer = min_block_time
	
	if player.has_node("Sprite"):
		player.get_node("Sprite").play("Block")
		
	# Toca som de bloqueio se tiver
	var audio = find_child("AudioStreamPlayer")
	if audio: audio.play()

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.velocity.x = 0 # Fica parada defendendo
	
	block_timer -= delta
	
	var target = player.target
	
	# Se o tempo mínimo passou...
	if block_timer <= 0:
		# ... e o jogador NÃO está mais atacando, solta o bloqueio
		if target and target.get("current_state"):
			var s_name = target.current_state.name
			# Se o player parou de bater, a IA volta para Idle
			if s_name not in ["Punch", "Kick", "Jump Kick"]:
				return idle_state
		else:
			return idle_state
			
	player.move_and_slide()
	return null
