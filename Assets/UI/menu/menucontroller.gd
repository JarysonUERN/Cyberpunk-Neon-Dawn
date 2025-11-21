extends Control

func _ready() -> void:
	play_music
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)
	$VBoxContainer/Start.pressed.connect(start_main)
	
func _on_exit_pressed() -> void:
	get_tree().quit()
func play_music() -> void:
	var music_player = $MusicPlayer
	if music_player.stream == null:
		# Se quiser carregar o MP3 via código
		music_player.stream = load("res://Assets/music/Cyberpunk Soundtrack - I REALLY WANT TO STAY AT YOUR HOUSE (8 Bit Raxlen Slice Chiptune Remix) [oiftRT1xjrU].mp3")
	play_music()
	
func start_main() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
