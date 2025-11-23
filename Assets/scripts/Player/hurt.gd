extends State

var switch_to_idle: bool = false

func enter() -> void:
	super()
	$AudioStreamPlayer.playing = true
	player.animation.animation_finished.connect(func(_name) -> void: switch_to_idle = true)

func exit() -> void:
	super()
	switch_to_idle = false

func process_frame(delta: float) -> State:
	if switch_to_idle and player.is_on_floor():
		return idle_state
	return null

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed(block):
		return block_state
	return null

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	return null
