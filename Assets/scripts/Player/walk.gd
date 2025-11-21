extends State

func enter() -> void:
	# Chama o pai para tocar a animação (definida no Inspector como "Run" ou "Walk")
	super() 

func process_physics(delta: float) -> State:
	# 1. PEGAR COMANDO: Usa as variáveis 'left' e 'right' que configuramos no script Pai
	var direction = Input.get_axis(left, right)
	
	# 2. REGRA DE SAÍDA: Se soltou as teclas (valor 0), volta para IDLE
	if direction == 0:
		return idle_state
	
	# 3. VISUAL: Virar o boneco para o lado certo
	if player.get_node_or_null("AnimatedSprite2D"):
		var sprite = player.get_node("AnimatedSprite2D")
		if direction < 0:
			sprite.flip_h = true  # Esquerda
		elif direction > 0:
			sprite.flip_h = false # Direita
			
	# 4. FÍSICA: Aplicar velocidade
	player.velocity.x = direction * move_speed
	
	# 5. GRAVIDADE: Chama o pai para aplicar gravidade e mover
	# Isso é importante porque o Pai também verifica se caiu num buraco (Fall State)
	var next_state = super.process_physics(delta)
	if next_state != null:
		return next_state
		
	return null
