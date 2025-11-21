extends State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.velocity.x = lerpf(player.velocity.x, 0.0, 10 * delta)
	player.move_and_slide()
	return null

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed(jump) and player.is_on_floor():
		return jump_state
	if (event.is_action_pressed(left) or event.is_action_pressed(right)) and player.is_on_floor():
		return walk_state
	if event.is_action_pressed(punch) and player.is_on_floor():
		return punch_state
	if event.is_action_pressed(kick) and player.is_on_floor():
		return kick_state
	if event.is_action_released(block) and player.is_on_floor():
		return idle_state
	return null
