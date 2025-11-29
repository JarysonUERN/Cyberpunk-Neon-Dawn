extends State

@export var return_state: State
@export var hitbox: Area2D
# REMOVIDO: @export var damage_amt: int = 10 (Já existe no state.gd)

func enter() -> void:
	super()
	
	if not hitbox:
		print("ERRO: Hitbox não configurada no Punch!")
		return

	# Configura o dano na hitbox usando a variável herdada do State
	if "damage" in hitbox:
		hitbox.damage = damage_amt # O script acha essa variável no pai (state.gd)
	
	# Força o monitoramento
	hitbox.monitoring = true
	hitbox.monitorable = true
	
	# Garante a conexão do sinal
	if not hitbox.area_entered.is_connected(_on_area_entered):
		hitbox.area_entered.connect(_on_area_entered)
		
	# Toca animação
	var animador = player.get_node_or_null("Player") # AnimationPlayer
	if animador:
		if not animador.animation_finished.is_connected(_on_animation_finished):
			animador.animation_finished.connect(_on_animation_finished)
		animador.play(animation_name)
	# Fallback para AnimatedSprite2D se não tiver AnimationPlayer
	elif player.has_node("Sprite"):
		player.get_node("Sprite").play(animation_name)
		# Cria um timer manual já que AnimatedSprite não tem animation_finished igual ao Player
		await get_tree().create_timer(0.3).timeout 
		_on_animation_finished(animation_name)

func _on_area_entered(area):
	# Ignora a si mesmo
	if area.owner == player:
		return

	print("Soco acertou: ", area.name)

	# Chama a função de dano no alvo
	if area.has_method("on_area_entered"):
		area.on_area_entered(hitbox)
		hitbox.set_deferred("monitoring", false) # Desativa para não acertar 2x

func _on_animation_finished(anim_name = ""):
	# Verificação simples para garantir que o estado não mudou no meio do caminho
	if player.current_state == self:
		hitbox.set_deferred("monitoring", false)
		player.change_state(return_state)

func exit():
	super()
	if hitbox:
		hitbox.set_deferred("monitoring", false)
