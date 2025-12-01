class_name EnemyHurtState
extends EnemyState


@export var return_state: EnemyState

func enter() -> void:
	super()

	player.velocity = Vector2.ZERO
	

	if player.state_machine.has_method("can_change_state_to_true"):
		player.state_machine.can_change_state_to_true()
	
	# Toca animação
	if player.has_node("Player"): # AnimationPlayer
		var anim = player.get_node("Player")
		anim.play(animation_name)
		if not anim.animation_finished.is_connected(_on_animation_finished):
			anim.animation_finished.connect(_on_animation_finished)
			
	elif player.has_node("Sprite"): # AnimatedSprite2D
		player.get_node("Sprite").play(animation_name)
		await get_tree().create_timer(0.4).timeout 
		_on_animation_finished()

func process_physics(_delta: float) -> EnemyState:
	# Aplica gravidade enquanto está machucado (para não travar no ar)
	player.velocity.y += gravity * _delta
	player.move_and_slide()
	return null

func _on_animation_finished(_anim_name = ""):
	# Segurança para destrancar a máquina
	if player.state_machine.has_method("can_change_state_to_true"):
		player.state_machine.can_change_state_to_true()
	
	# Volta para o estado normal
	if return_state:
		player.change_state(return_state)
	elif idle_state:
		player.change_state(idle_state)
	else:
		# Fallback de emergência se ninguém configurou o inspector
		push_warning("EnemyHurt: Sem estado de retorno configurado!")

func exit():
	super()
	# Destrava a máquina ao sair (Segurança extra)
	if player.state_machine.has_method("can_change_state_to_true"):
		player.state_machine.can_change_state_to_true()
		
	# Limpa conexões
	if player.has_node("Player"):
		var anim = player.get_node("Player")
		if anim.animation_finished.is_connected(_on_animation_finished):
			anim.animation_finished.disconnect(_on_animation_finished)
