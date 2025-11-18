extends Control

func _ready() -> void:
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)
	$VBoxContainer/Start.pressed.connect(start_main)
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func start_main() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
