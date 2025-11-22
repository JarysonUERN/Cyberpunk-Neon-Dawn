class_name State
extends Node

# --- CONFIGURAÇÕES ---
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_speed: float = 200.0
var jump_force: float = 450.0
var player: CharacterBody2D

@export var damage_amt: int = 10

# --- ESTADOS ---
@export var animation_name: String
@export var idle_state: State
@export var walk_state: State
@export var jump_state: State
@export var fall_state: State
@export var punch_state: State
@export var kick_state: State
@export var block_state: State
@export var jump_kick_state: State

# --- TECLAS ---
@export var left: String = "p1_left"
@export var right: String = "p1_right"
@export var jump: String = "p1_jump"
@export var punch: String = "p1_punch"
@export var kick: String = "p1_kick"
@export var block: String = "p1_block"

func enter() -> void:
	# --- CORREÇÃO PARA ANIMATION PLAYER ---
	# O seu nó de animação se chama "Player" (o rolo de filme 🎞️)
	# Mas a variável 'player' já é o personagem. Vamos usar get_node para achar o animador.
	
	if player.has_node("Player"): # Procura o nó com ícone de filme
		var animador = player.get_node("Player")
		
		# Verifica se é mesmo um AnimationPlayer
		if animador is AnimationPlayer:
			if animador.has_animation(animation_name):
				animador.play(animation_name)
			else:
				print("ERRO: O AnimationPlayer não tem a animação: ", animation_name)
	
	# Caso você mude de ideia e use AnimatedSprite2D no futuro
	elif player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	if player.is_on_floor():
		if event.is_action_pressed(jump):
			return jump_state
		if event.is_action_pressed(punch):
			return punch_state
		if event.is_action_pressed(kick):
			return kick_state
		if event.is_action_pressed(block):
			return block_state
	return null

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	if !player.is_on_floor():
		return fall_state
	return null
