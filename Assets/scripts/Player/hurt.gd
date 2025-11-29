extends State

@export var knockback_duration: float = 0.3# Tempo curto e seco
@export var friction: float = 1500.0 # Atrito muito alto para parar rápido

var timer: float = 0.0

func enter() -> void:
	super()
	timer = knockback_duration
	
	if has_node("AudioStreamPlayer"):
		$AudioStreamPlayer.play()
	
	# Força a animação
	if player.has_node("Sprite"):
		player.get_node("Sprite").play("Hurt")

func process_physics(delta: float) -> State:
	# Aplica gravidade (para garantir que ele fique no chão)
	player.velocity.y += gravity * delta
	
	if timer > 0:
		timer -= delta
		
		# FREIO ABSOLUTO: Reduz a velocidade X drasticamente a cada frame
		player.velocity.x = move_toward(player.velocity.x, 0, friction * delta)
		
		player.move_and_slide()
		return null 
		
	else:
		player.velocity.x = 0
		player.velocity.y = 0
		
		# Agora sim, pode sair
		if not player.is_on_floor():
			return fall_state
		else:
			return idle_state
func process_input(event: InputEvent) -> State:
	return null
func exit() -> void:
	super()
	player.velocity.x = 0
