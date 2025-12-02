extends Control

# Variável para você arrastar a Cutscene no Inspetor
@export var cena_cutscene: PackedScene

func _ready() -> void:
	play_music() # Corrigido: Faltava os parênteses () para funcionar
	
	# Conexões dos botões
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)
	$VBoxContainer/Start.pressed.connect(start_cutscene) # Mudamos para chamar a cutscene
	$VBoxContainer/MenuOption.pressed.connect(options)

func _on_exit_pressed() -> void:
	get_tree().quit()

func play_music() -> void:
	# Garanta que este caminho ($MusicPlayer) bate com o nome na árvore!
	var music_player = $MusicPlayer 
	
	if music_player: # Verifica se o nó existe para não travar o jogo
		if music_player.stream == null:
			music_player.stream = load("res://Assets/music/Cyberpunk Soundtrack - I REALLY WANT TO STAY AT YOUR HOUSE (8 Bit Raxlen Slice Chiptune Remix) [oiftRT1xjrU].mp3")
		
		if not music_player.playing:
			music_player.play()
	else:
		print("ERRO: Nó MusicPlayer não encontrado na cena!")
	
func start_cutscene() -> void:
	# Verifica se você colocou a cutscene no Inspetor antes de trocar
	if cena_cutscene:
		get_tree().change_scene_to_packed(cena_cutscene)
	else:
		print("ERRO: Você esqueceu de arrastar o arquivo Cutscene1.tscn para o Inspetor do Menu!")

func options():
	get_tree().change_scene_to_file("res://Assets/UI/menu/optionsmenu.tscn")
