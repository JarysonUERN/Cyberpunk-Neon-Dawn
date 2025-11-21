extends Node

@export var health: int = 100
@export var freeze_slow: float = 0.01
@export var freeze_time: float = 1000000 # Isso é muito tempo, mas ok se for intencional

# --- CORREÇÃO AQUI: Atualize o caminho para o novo nome que você deu ---
# Se o nó da barra agora se chama "health___bar", o caminho deve ser este:
@onready var health_bar = $"../CanvasLayer/health_bar"

# Alternativa: Se "health___bar" for uma pasta e o nó ainda for HealthBar:
# @onready var health_bar = $"../CanvasLayer/health___bar/HealthBar"

@onready var player = get_parent()

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var trig_death: bool = false
var trig_lerp: bool = false

func _ready():
	# --- CORREÇÃO AQUI: Mudado de 'health_ui' para 'health_bar' ---
	if health_bar != null:
		# Verifica se a função existe antes de chamar para evitar crash
		if health_bar.has_method("_init_health"):
			health_bar._init_health(health)
		else:
			print("Erro: O script da HealthBar não tem a função '_init_health'")
	else:
		print("AVISO: Caminho do HealthBar incorreto no script health.gd!")

func deal_damage(damage: int) -> void:
	health -= damage
	
	# Só tenta atualizar a barra se ela existir
	if health_bar != null and health_bar.has_method("_set_health"):
		health_bar._set_health(health)
		
	if health <= 0:
		trig_death = true
		trig_lerp = true

func _process(delta):
	if trig_death:
		trig_death = false
		# Verifica se a animação existe para não crashar
		if player.has_node("AnimationPlayer") or "animation" in player:
			 # Se for AnimatedSprite2D usa .play(), se for AnimationPlayer usa .play()
			 # Ajuste conforme seu player
			player.animation.play("Death")
		engine_slow()

func _physics_process(delta):
	if trig_lerp:
		# Verifica se o player é um CharacterBody2D antes de mover
		if player is CharacterBody2D:
			player.velocity.y += gravity * delta
			player.velocity.x = lerpf(player.velocity.x, 0.0, 10 * delta)
			player.move_and_slide()

func engine_slow() -> void:
	Engine.time_scale = freeze_slow
	await get_tree().create_timer(freeze_slow * freeze_time).timeout
	Engine.time_scale = 1
