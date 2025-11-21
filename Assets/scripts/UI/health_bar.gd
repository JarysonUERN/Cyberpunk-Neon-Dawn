extends ProgressBar

@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer

var health: int = 0 : set = _set_health

func _set_health(new_health: int) -> void:
	var prev_health: int = health
	health = min(max_value, new_health)
	value = health

	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func _init_health(_health) -> void:
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout():
	damage_bar.value = health
