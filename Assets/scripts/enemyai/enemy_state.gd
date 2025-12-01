class_name EnemyState
extends Node

# --- CONFIGURAÇÕES FÍSICAS ---
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_speed: float = 150.0 
var jump_force: float = 400.0

# Referência ao próprio Inimigo
var player: CharacterBody2D

# --- COMBATE ---
@export var damage_amt: int = 10

# --- REFERÊNCIAS DE ESTADOS (Tipados como EnemyState) ---
@export var animation_name: String
@export var idle_state: EnemyState
@export var walk_state: EnemyState 
@export var jump_state: EnemyState
@export var fall_state: EnemyState
@export var punch_state: EnemyState
@export var kick_state: EnemyState
@export var block_state: EnemyState
@export var jump_kick_state: EnemyState

func enter() -> void:
	# Prioridade 1: Tenta achar o nó com o nome "Sprite"
	if player.has_node("Sprite"):
		var sprite = player.get_node("Sprite")
		if animation_name != "":
			if sprite is AnimatedSprite2D and sprite.sprite_frames.has_animation(animation_name):
				sprite.play(animation_name)
			elif player.has_node("Player"): # AnimationPlayer
				player.get_node("Player").play(animation_name)
		
	# Prioridade 2: AnimatedSprite2D genérico
	elif player.has_node("AnimatedSprite2D"):
		var sprite = player.get_node("AnimatedSprite2D")
		if animation_name != "":
			sprite.play(animation_name)

func exit() -> void:
	pass


func process_physics(delta: float) -> EnemyState:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	
	if !player.is_on_floor() and fall_state:
		return fall_state
		
	return null

func get_target() -> CharacterBody2D:
	if "target" in player:
		return player.target
	return null
