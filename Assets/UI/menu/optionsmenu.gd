extends Control

var main_scene: Node = null

func set_main_scene(scene: Node) -> void:
	main_scene = scene

func _ready() -> void:
	# Conectar os botões
	$Label/VBoxContainer/MainmenuButton.pressed.connect(_on_mainmenu_pressed)
	$Label/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)
	$"Toggle Music".pressed.connect(_on_toggle_music_pressed)
	$"Visit Github".pressed.connect(_visit_github)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_mainmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/UI/menu/menucontroller.tscn")

func _on_toggle_music_pressed() -> void:
	if main_scene and main_scene.has_method("toggle_music"):
		main_scene.toggle_music()

func _visit_github() -> void:
	OS.shell_open("https://github.com/JarysonUERN/Cyberpunk-Neon-Dawn")
