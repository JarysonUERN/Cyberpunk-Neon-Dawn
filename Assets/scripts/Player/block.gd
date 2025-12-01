extends State

func enter() -> void:
	super()
	player.velocity.x = 0 
	
	if player.has_node("Sprite"):
		player.get_node("Sprite").play("Block")
		
	var audio = find_child("AudioStreamPlayer") # 
	if audio: 
		audio.play()

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.velocity.x = move_toward(player.velocity.x, 0.0, 1000 * delta)
	player.move_and_slide()
	return null

func process_input(event: InputEvent) -> State:
	if event.is_action_released(block):
		return idle_state
	
	

	if event.is_action_pressed(punch) and player.is_on_floor():
		return punch_state
	if event.is_action_pressed(kick) and player.is_on_floor():
		return kick_state

	return null
