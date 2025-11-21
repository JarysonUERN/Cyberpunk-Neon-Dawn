extends State

var switch_to_idle: bool = false

func enter() -> void:
	super()
	$AudioStreamPlayer.playing = true
	damage_amt = 10
	switch_to_idle = false
	get_child(0).damage = damage_amt
	player.animation.animation_finished.connect(func(_name) -> void: switch_to_idle = true)

func exit() -> void:
	super()
	get_child(0).get_child(0).set_deferred("disabled", true)
	switch_to_idle = false

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed(block):
		return block_state
	return null

func process_frame(delta) -> State:
	if switch_to_idle:
		return idle_state
	return null
