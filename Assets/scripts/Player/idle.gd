extends State

func enter() -> void:
	super()
	player.velocity.x = 0
	
func process_physics(delta: float) -> State:
	# Verifica se apertou A ou D
	if Input.get_axis(left, right) != 0:
		return walk_state # Troca para o Walk
	
	# Aplica gravidade e retorna
	return super.process_physics(delta)
