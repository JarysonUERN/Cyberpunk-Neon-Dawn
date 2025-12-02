class_name EnemyPunch
extends EnemyState 

# MUDANÇA: Tipo deve ser EnemyState
@export var return_state: EnemyState
@export var hitbox: Area2D

func enter() -> void:
	super()
	
	if hitbox:
		if "damage" in hitbox:
			hitbox.damage = damage_amt 
		hitbox.monitoring = true
		hitbox.monitorable = true
		if not hitbox.area_entered.is_connected(_on_area_entered):
			hitbox.area_entered.connect(_on_area_entered)

	# Toca animação
	if player.has_node("Player"):
		var anim = player.get_node("Player")
		anim.play(animation_name)
		if not anim.animation_finished.is_connected(_on_animation_finished):
			anim.animation_finished.connect(_on_animation_finished)
	elif player.has_node("Sprite"):
		player.get_node("Sprite").play(animation_name)
		await get_tree().create_timer(0.4).timeout 
		_on_animation_finished()

func _on_area_entered(area):
	if area.owner == player: return
	if area.has_method("on_area_entered"):
		area.on_area_entered(hitbox)
		hitbox.set_deferred("monitoring", false)

func _on_animation_finished(_anim_name = ""):
	if player.state_machine.has_method("can_change_state_to_true"):
		player.state_machine.can_change_state_to_true()
	
	if player.current_state == self:
		# Verifica se return_state foi configurado, senão tenta ir para Idle
		if return_state:
			player.change_state(return_state)
		elif idle_state:
			player.change_state(idle_state)

func exit():
	super()
	if hitbox:
		hitbox.set_deferred("monitoring", false)
	if player.state_machine.has_method("can_change_state_to_true"):
		player.state_machine.can_change_state_to_true()
	if player.has_node("Player"):
		var anim = player.get_node("Player")
		if anim.animation_finished.is_connected(_on_animation_finished):
			anim.animation_finished.disconnect(_on_animation_finished)
