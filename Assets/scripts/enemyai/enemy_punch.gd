class_name EnemyPunchState
extends State

# Para onde o inimigo volta depois de socar (geralmente Idle ou Chase)
@export var return_state: State
@export var hitbox: Area2D

func enter() -> void:
	super()
	
	# 1. Configuração da Hitbox (Área de Dano)
	if hitbox:
		# Define o dano usando a variável base do state.gd
		if "damage" in hitbox:
			hitbox.damage = damage_amt 
			
		hitbox.monitoring = true
		hitbox.monitorable = true
		
		# Conecta o sinal de colisão apenas se ainda não estiver conectado
		if not hitbox.area_entered.is_connected(_on_area_entered):
			hitbox.area_entered.connect(_on_area_entered)
	else:
		push_warning("Aviso: Hitbox não configurada no Enemy Punch!")

	# 2. Toca a Animação
	# A IA tenta usar o AnimationPlayer (preferencial) ou Sprite (fallback)
	if player.has_node("Player"):
		var anim = player.get_node("Player")
		anim.play(animation_name)
		
		# Conecta o fim da animação com segurança
		if not anim.animation_finished.is_connected(_on_animation_finished):
			anim.animation_finished.connect(_on_animation_finished)
			
	elif player.has_node("Sprite"): # Fallback para AnimatedSprite2D
		player.get_node("Sprite").play(animation_name)
		# Timer de segurança caso não tenha AnimationPlayer
		await get_tree().create_timer(0.4).timeout 
		_on_animation_finished()

# Lógica de causar dano quando acerta
func _on_area_entered(area):
	# Ignora colisão com o próprio dono (Inimigo)
	if area.owner == player: 
		return

	# Se a área acertada tiver script de receber dano (Hurtbox)
	if area.has_method("on_area_entered"):
		area.on_area_entered(hitbox)
		
		# Desativa a hitbox imediatamente para não causar dano duplo no mesmo soco
		hitbox.set_deferred("monitoring", false)

# Lógica de fim do ataque (Crucial para evitar travamentos)
func _on_animation_finished(_anim_name = ""):
	# --- TRAVA DE SEGURANÇA ---
	# Força a máquina a aceitar troca de estado, ignorando travas da animação
	if player.state_machine.has_method("can_change_state_to_true"):
		player.state_machine.can_change_state_to_true()
	
	# Confirma se este ainda é o estado ativo antes de tentar sair
	if player.current_state == self:
		player.change_state(return_state)

func exit():
	super()
	# Desativa a hitbox ao sair do estado
	if hitbox:
		hitbox.set_deferred("monitoring", false)
	
	# SEGURANÇA EXTRA: Destrava a máquina ao sair
	# Isso impede que o inimigo trave se for interrompido (ex: levou dano no meio do soco)
	if player.state_machine.has_method("can_change_state_to_true"):
		player.state_machine.can_change_state_to_true()
		
	# Limpa conexões para evitar erros de referência
	if player.has_node("Player"):
		var anim = player.get_node("Player")
		if anim.animation_finished.is_connected(_on_animation_finished):
			anim.animation_finished.disconnect(_on_animation_finished)
