class_name EnemyJumpKickState
extends EnemyState

@export var hitbox: Area2D
@export var kick_damage: int = 20
@export var air_speed: float = 150.0 #

func enter() -> void:
	super()
	if hitbox:
		if "damage" in hitbox:
			hitbox.damage = kick_damage
		
		hitbox.monitoring = true
		hitbox.monitorable = true
		
		# Conecta o sinal apenas se não estiver conectado
		if not hitbox.area_entered.is_connected(_on_area_entered):
			hitbox.area_entered.connect(_on_area_entered)
	else:
		push_warning("Aviso: Hitbox não configurada no Enemy Jump Kick!")

	# 2. Tocar Animação (Suporte a AnimationPlayer e AnimatedSprite2D)
	if player.has_node("Player"): # AnimationPlayer
		var anim = player.get_node("Player")
		anim.play(animation_name)
		
		# Conecta o sinal de fim de animação com segurança
		if not anim.animation_finished.is_connected(_on_animation_finished):
			anim.animation_finished.connect(_on_animation_finished)
			
	elif player.has_node("Sprite"): # Fallback Sprite
		player.get_node("Sprite").play(animation_name)
		# Se não tiver AnimationPlayer, usamos um timer ou esperamos tocar o chão

func process_physics(delta: float) -> EnemyState:
	# Aplica gravidade
	player.velocity.y += gravity * delta
	
	# --- LÓGICA DE MOVIMENTO DA IA ---
	# Diferente do Player, a IA precisa "decidir" ir para frente enquanto chuta
	var target = get_target()
	if target:
		var dir_x = sign(target.global_position.x - player.global_position.x)
		
		player.velocity.x = move_toward(player.velocity.x, dir_x * air_speed, 10.0)
		
		_flip_sprite(dir_x)
	
	player.move_and_slide()
	
	if player.is_on_floor():
		return idle_state
		
	return null

func _on_area_entered(area):
	if area.owner == player: 
		return
	
	# Aplica dano no player
	if area.has_method("on_area_entered"):
		area.on_area_entered(hitbox)
		hitbox.set_deferred("monitoring", false)

func _on_animation_finished(_anim_name = ""):
	if player.state_machine.has_method("can_change_state_to_true"):
		player.state_machine.can_change_state_to_true()

	
	if player.current_state == self:
		if not player.is_on_floor():
			return # Deixa o process_physics lidar com a queda ou muda para fall_state
		else:
			player.change_state(idle_state)

func exit() -> void:
	super()
	
	# Desativa Hitbox
	if hitbox:
		hitbox.set_deferred("monitoring", false)
	
	# Limpa conexões do AnimationPlayer
	if player.has_node("Player"):
		var anim = player.get_node("Player")
		if anim.animation_finished.is_connected(_on_animation_finished):
			anim.animation_finished.disconnect(_on_animation_finished)
			
	# Segurança extra para garantir que a IA não trave
	if player.state_machine.has_method("can_change_state_to_true"):
		player.state_machine.can_change_state_to_true()

# Função auxiliar visual (opcional, se já não tiver no pai)
func _flip_sprite(dir_x: float):
	if dir_x == 0: return
	var visual_node = null
	if player.has_node("AnimatedSprite2D"): visual_node = player.get_node("AnimatedSprite2D")
	elif player.has_node("Sprite"): visual_node = player.get_node("Sprite")
	
	if visual_node:
		# Lógica de virar baseada na escala ou flip_h
		if visual_node.scale.x > 0 and dir_x < 0: visual_node.scale.x *= -1
		elif visual_node.scale.x < 0 and dir_x > 0: visual_node.scale.x *= -1
