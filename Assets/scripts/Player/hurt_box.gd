extends HurtBox

@onready var state_machine: StateMachine = $"../.."
@onready var hurt_state: State = $".."
@onready var block_state: State = $"../../Block"
@onready var particles: CPUParticles2D = $"../../../Hurt Particles"
@onready var player: CharacterBody2D = $"../../.."
@onready var camera: Camera2D = $"../../../../Camera"
@onready var health_node: Node = $"../../../Health"



func on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	
	engine_slow()
	handle_particles(hitbox)
	handle_push_back(hitbox)
	handle_camera()

	if state_machine.current_state != block_state:
		health_node.deal_damage(hitbox.damage)
		state_machine.can_change_state_to_true()
		state_machine.change_state(hurt_state)
	else:
		$"../../Block/AudioStreamPlayer".playing = true

func handle_particles(hitbox: HitBox) -> void:
	particles.gravity = particles.gravity.length() * (hitbox.global_position - global_position).normalized()
	particles.emitting = true

func handle_push_back(hitbox: HitBox) -> void:
	var push_back_force: Vector2 = (global_position - hitbox.global_position).normalized() * 150;
	player.velocity = push_back_force
	player.move_and_slide()

func handle_camera() -> void:
	camera.shake_str = camera.rand_str
	camera.zm_fc = 1.1
