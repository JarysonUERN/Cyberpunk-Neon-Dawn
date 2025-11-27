extends Control
func _ready() -> void:
	$Label/VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	$Label/VBoxContainer/MainmenuButton.pressed.connect(_on_mainmenu_pressed)
	$Label/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_mainmenu_pressed():
	get_tree().change_scene_to_file("res://Assets/UI/menu/menucontroller.tscn")
