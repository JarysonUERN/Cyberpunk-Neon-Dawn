extends EnemyState

# Distância para a IA perceber o jogador e começar a perseguir
@export var detect_range: float = 300.0

func enter() -> void:
	super() # O super já tenta tocar a animação definida no Inspector
	player.velocity.x = 0
	
	# Reforço para garantir que a animação toque
	if player.has_node("Sprite"):
		player.get_node("Sprite").play("Idle")
	elif player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("Idle")

func process_physics(delta: float) -> EnemyState:
	# 1. Aplica Gravidade
	player.velocity.y += gravity * delta
	
	var target = get_target() 
	
	if target:
		# Calcula a distância até o alvo
		var dist = player.global_position.distance_to(target.global_position)
		
		# Se o jogador estiver perto o suficiente, muda para perseguição (Walk)
		if dist < detect_range:
			return walk_state
	
	# 3. Verifica se caiu do chão
	if !player.is_on_floor():
		return fall_state
	
	player.move_and_slide()
	return null
