class_name HurtBox
extends Area2D

@export var freeeze_slow: float = 0.09
@export var freeze_time: float = 0.3

func _init() -> void:
	collision_layer = 0
	collision_mask = 4

func _ready() -> void:
	self.area_entered.connect(on_area_entered)

func on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	
	engine_slow()

func engine_slow() -> void:
	Engine.time_scale = freeeze_slow
	await get_tree().create_timer(freeeze_slow * freeze_time).timeout
	Engine.time_scale = 1
