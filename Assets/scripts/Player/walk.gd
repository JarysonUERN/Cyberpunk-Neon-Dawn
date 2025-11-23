extends State # Se você não mudou o nome da classe Pai, use "extends State"

func enter() -> void:
	# --- A MÁGICA DA ANIMAÇÃO ---
	# Essa linha manda o script Pai ler o "Animation Name" do Inspector ("Walk")
	# e mandar o Sprite tocar essa animação.
	super()

func process_physics(delta: float) -> State:
	# 1. Lê as teclas (usando as variáveis configuradas no Pai: p1_left / p1_right)
	var direction = Input.get_axis(left, right)
	
	# 2. Se parou de andar, volta para IDLE
	if direction == 0:
		return idle_state
	
	# 3. Vira o boneco para o lado certo
	# Usamos get_node("Sprite") porque esse é o nome na sua árvore de cena
	var visual = player.get_node("Sprite")
	
	if direction < 0:
		visual.flip_h = true  # Olha para esquerda
	elif direction > 0:
		visual.flip_h = false # Olha para direita
		
	# 4. Define a velocidade
	player.velocity.x = direction * move_speed
	
	# 5. Chama o Pai para aplicar gravidade e mover
	# Isso também verifica se ele caiu num buraco (Fall State)
	return super.process_physics(delta)
