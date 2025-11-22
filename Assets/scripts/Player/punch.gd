extends State # (ou extends State)

@export var return_state: State
@export var hitbox: Area2D

# --- CORREÇÃO: REMOVIDA A LINHA ABAIXO POIS JÁ EXISTE NO PAI (State.gd) ---
# @export var damage_amt: int = 10 

func enter() -> void:
	if player == null:
		player = get_parent().get_parent()
		if player == null: player = owner

	player.velocity.x = 0
	
	# --- LIGAR HITBOX COM DIAGNÓSTICO ---
	if hitbox:
		hitbox.monitoring = true
		if not hitbox.body_entered.is_connected(_on_body_entered):
			hitbox.body_entered.connect(_on_body_entered)
		print(">> Soco INICIADO. Hitbox ativada e monitorando!")
	else:
		print(">> ERRO CRÍTICO: Campo 'Hitbox' vazio no Inspector do Punch!")
	
	# Conexão da animação
	var animador = null
	if player.has_node("Player"):
		animador = player.get_node("Player")
		if not animador.animation_finished.is_connected(_on_animation_finished):
			animador.animation_finished.connect(_on_animation_finished)
	elif player.has_node("Sprite"):
		animador = player.get_node("Sprite")
		if not animador.animation_finished.is_connected(_on_animation_finished):
			animador.animation_finished.connect(_on_animation_finished)

	super()
	
	# Timer de segurança
	if animador:
		var tempo = animador.current_animation_length
		if tempo <= 0: tempo = 0.5
		await get_tree().create_timer(tempo + 0.05).timeout
		if player.current_state == self:
			_on_animation_finished(animation_name)

func _on_body_entered(body):
	print("\n--- 🔍 DIAGNÓSTICO DE COLISÃO ---")
	print(">> A Hitbox tocou em algo: ", body.name)
	
	if body == player:
		print(">> É o próprio jogador. Ignorando.")
		return
		
	# Verifica se o corpo tem o nó de vida (Health)
	if body.has_node("Health"):
		print(">> SUCESSO: Encontrei o nó 'Health' em ", body.name)
		var health_script = body.get_node("Health")
		
		if health_script.has_method("deal_damage"):
			# damage_amt vem do script Pai (State.gd) automaticamente!
			print(">> SUCESSO: O script tem 'deal_damage'. Aplicando ", damage_amt, " de dano.")
			health_script.deal_damage(damage_amt)
			
			if hitbox:
				hitbox.set_deferred("monitoring", false)
		else:
			print(">> ERRO: O nó 'Health' existe, mas NÃO tem a função 'deal_damage' no script!")
			
	elif body.has_node("HealthManager"):
		print(">> AVISO: Encontrei 'HealthManager' em vez de 'Health'. Atualize o código se for esse o nome!")
		
	else:
		print(">> ERRO: O corpo ", body.name, " NÃO tem um nó chamado 'Health'.")
		print(">> Lista de filhos encontrados em ", body.name, ":")
		for child in body.get_children():
			print("   - ", child.name)
	print("----------------------------------\n")

func _on_animation_finished(anim_name = ""):
	if anim_name == animation_name or anim_name == "":
		if return_state:
			player.change_state(return_state)

func exit() -> void:
	super()
	if hitbox:
		hitbox.monitoring = false
		if hitbox.body_entered.is_connected(_on_body_entered):
			hitbox.body_entered.disconnect(_on_body_entered)
	
	if player.has_node("Player"):
		var animador = player.get_node("Player")
		if animador.animation_finished.is_connected(_on_animation_finished):
			animador.animation_finished.disconnect(_on_animation_finished)

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	return null
