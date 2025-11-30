extends State
@export var chase_speed: float = 80.0 

func enter() -> void:
	super()
	# Toca animação de andar
	if player.has_node("Sprite"): 
		player.get_node("Sprite").play("Walk")
	elif player.has_node("AnimatedSprite2D"): 
		player.get_node("AnimatedSprite2D").play("Walk")

func process_physics(delta: float) -> State:
	# 1. Aplica Gravidade
	player.velocity.y += gravity * delta
	
	# 2. Obtém o alvo (que está guardado no script EnemyAI)
	var target = player.get("target")
	
	if not target:
		return idle_state # Usa a variável herdada do pai
	
	# 3. Calcula Distância
	var distance = player.global_position.distance_to(target.global_position)
	var direction = (target.global_position - player.global_position).normalized()
	
	# Busca o range de ataque
	var range_to_attack = player.get("attack_range")
	if range_to_attack == null: range_to_attack = 40.0
	
	# 4. Lógica: Se longe, persegue. Se perto, ataca.
	if distance > range_to_attack:
		# Move em direção ao jogador
		player.velocity.x = direction.x * chase_speed
		
		# Espelha o sprite para olhar para o alvo
		if direction.x > 0:
			player.scale.x = 1  # Olha pra direita
		elif direction.x < 0:
			player.scale.x = -1 # Olha pra esquerda
			
	else:
		# Chegou perto! Para e soca.
		player.velocity.x = 0
		return punch_state # Usa a variável herdada do pai
		
	player.move_and_slide()
	return null
