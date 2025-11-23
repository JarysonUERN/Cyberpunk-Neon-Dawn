extends Node

@onready var players: Array[Node] = [$"../Brawler Girl/Health", $"../Fighter Girl/Health"]

var play_sound: bool = true
var enable_restart: bool = false

func _process(delta):
	if play_sound:
		if players[0].health <= 0 and players[1].health <= 0:
			play_sound = false
			enable_restart = true
			$"../CanvasLayer/RichTextLabel".visible = true
			$"../Tie".playing = true
		elif players[0].health <= 0 or players[1].health <= 0:
			play_sound = false
			enable_restart = true
			$"../CanvasLayer/RichTextLabel".visible = true
			$"../Win".playing = true
	if enable_restart and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
