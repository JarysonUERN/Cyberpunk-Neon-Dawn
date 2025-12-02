extends Node

signal died(player_ref)

@export var health: int = 100
@export var freeze_slow: float = 0.05
@export var freeze_time: float = 0.3

@onready var health_bar_node = $"../CanvasLayer/HealthBar"
@onready var player = get_parent()

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var trig_death: bool = false

func _ready():
	if health_bar_node:
		if health_bar_node.has_method("_init_health"):
			health_bar_node._init_health(health)
	else:
		print("ERRO: HealthBar não encontrada no caminho ../CanvasLayer/HealthBar")

func deal_damage(damage: int) -> void:
	if trig_death:
		return

	print("Vida antes: ", health, "| Dano: ", damage)
	health -= damage
	print("Vida depois: ", health)
	
	if health_bar_node and health_bar_node.has_method("_set_health"):
		health_bar_node._set_health(health)
		
	if health <= 0:
		die()

func die():
	if trig_death:
		return
	trig_death = true
	
	print(player.name + " MORREU!")

	emit_signal("died", player)   # <--- Aqui avisa a Main

	# Animação
	if player.has_node("Player"):
		player.get_node("Player").play("Death")
	elif player.has_node("Sprite"):
		player.get_node("Sprite").play("Hurt")

	engine_slow()

func engine_slow() -> void:
	Engine.time_scale = freeze_slow
	await get_tree().create_timer(freeze_slow * freeze_time).timeout
	Engine.time_scale = 1
