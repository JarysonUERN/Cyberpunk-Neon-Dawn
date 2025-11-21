extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/RestartButton.pressed.connect(restartpressed)
	$VBoxContainer/ExitButton.pressed.connect(exitpressed)
	$VBoxContainer/MainmenuButton.pressed.connect(mainmenupressed)
	
	pass # Replace with function body.
func restartpressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

	
func exitpressed() -> void:
	get_tree().quit()

	
func mainmenupressed() -> void:
	get_tree().change_scene_to_file("res://Assets/UI/menu/menucontroller.tscn")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
