extends State

func enter() -> void:
	super()

func proces_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	
	if Input.is_action_just_pressed(kick):
		return jump_kick_state
	
	var movement = Input.get_axis(left, right) * move_speed
	
	if movement < 0:
		player.sprite.flip_h = true
	elif movement > 0:
		player.sprite.flip_h = false
	
	player.velocity.x = movement
	player.move_and_slide()
	
	if player.is_on_floor():
		$AudioStreamPlayer.playing = true
		if movement != 0:
			return walk_state
		return idle_state
	return null
