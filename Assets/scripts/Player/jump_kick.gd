extends State

@export var hitbox: Area2D
@export var kick_damage:  int = 20
func enter() -> void:
	super()
	
	if hitbox:
		#s
		if "damage" in hitbox:
			hitbox.damage = kick_damage
		
		hitbox.monitoring = true
		hitbox.monitorable = true
		
	
		if not hitbox.area_entered.is_connected(_on_area_entered):
			hitbox.area_entered.connect(_on_area_entered)
	else:
		print("ERRO: Hitbox não configurada no JumpKick!")


	var animador = player.get_node_or_null("Player") # AnimationPlayer
	if animador:
		if not animador.animation_finished.is_connected(_on_animation_finished):
			animador.animation_finished.connect(_on_animation_finished)
		animador.play(animation_name)
	elif player.has_node("Sprite"):
		player.get_node("Sprite").play(animation_name)

func process_physics(delta: float) -> State:
	
	player.velocity.y += gravity * delta
	player.move_and_slide()
	
	
	if player.is_on_floor():
		return idle_state
		
	return null

func _on_area_entered(area):
	if area.owner == player: return
	
	if area.has_method("on_area_entered"):
		area.on_area_entered(hitbox)
		

func _on_animation_finished(anim_name = ""):
	if player.current_state == self:
		if not player.is_on_floor():
			player.change_state(fall_state)
		else:
			player.change_state(idle_state)

func exit() -> void:
	super()
	if hitbox:
		hitbox.set_deferred("monitoring", false)
