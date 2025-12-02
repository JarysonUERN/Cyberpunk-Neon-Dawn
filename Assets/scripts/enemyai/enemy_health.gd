extends Node

@export var health: int = 100
@export var freeze_slow: float = 0.05
@export var freeze_time: float = 0.3

# --- CORREÇÃO DO CAMINHO ---
# O nó Health é irmão do CanvasLayer. O caminho correto é subir um nível (..) e entrar no CanvasLayer
@onready var health_bar_node = $"../CanvasLayer/HealthBar" 
@onready var player = get_parent()

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var trig_death: bool = false

func _ready():
	if health_bar_node:
		# Inicializa a barra visual com a vida total
		if health_bar_node.has_method("_init_health"):
			health_bar_node._init_health(health)
	else:
		print("ERRO: HealthBar não encontrada no caminho ../CanvasLayer/HealthBar")

func deal_damage(damage: int) -> void:
	print("Vida antes: ", health, " | Dano recebido: ", damage)
	health -= damage
	print("Vida atual: ", health)
	
	# Atualiza a barra visual
	if health_bar_node and health_bar_node.has_method("_set_health"):
		health_bar_node._set_health(health)
		
	if health <= 0:
		die()

func die():
	if trig_death: return
	trig_death = true
	
	print(player.name + " MORREU!")
	
	# Tenta tocar animação de morte
	if player.has_node("Player"): # AnimationPlayer
		player.get_node("Player").play("Death")
	elif player.has_node("Sprite"): # AnimatedSprite2D
		player.get_node("Sprite").play("Hurt") # Ou animação de morte específica
		
	engine_slow()

func engine_slow() -> void:
	Engine.time_scale = freeze_slow
	await get_tree().create_timer(freeze_slow * freeze_time).timeout
	Engine.time_scale = 1
