extends Node

# Referências
@onready var player1 = $"Brawler Girl"
@onready var player2 = $"Fighter Girl"
@onready var music_player = $MusicPlayer
@onready var win_text = $CanvasLayer/RichTextLabel
@onready var sound_win = $WinSound
@onready var sound_tie = $TieSound

# Estado
var game_is_running = true
var enable_restart = false

func _ready():
	# --- Conectar sinais de morte ---
	player1.get_node("Health").connect("died", Callable(self, "_on_player_died"))
	player2.get_node("Health").connect("died", Callable(self, "_on_player_died"))

	# Bot IA escolhe um alvo
	if player2 and "target" in player2:
		player2.target = player1

	new_game()

func _process(_delta):
	pause()

	if enable_restart:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
		return

	check_game_over_conditions()

# -----------------------------------
# FUNÇÕES PRINCIPAIS DO JOGO
# -----------------------------------

func new_game():
	game_is_running = true
	enable_restart = false
	win_text.visible = false

	play_music()

# CHAMADA PELO SINAL dos players
func _on_player_died(player_ref):
	print("Main recebeu: ", player_ref.name, " morreu")
	get_tree().change_scene_to_file("res://Assets/UI/menu/gameover_menu.tscn")

func check_game_over_conditions():
	var p1_dead = player1.get_node("Health").health <= 0
	var p2_dead = player2.get_node("Health").health <= 0

	if not game_is_running:
		return

	if p1_dead and p2_dead:
		finish_game("tie")
	elif p1_dead or p2_dead:
		finish_game("win")

func finish_game(result: String):
	game_is_running = false
	enable_restart = true
	win_text.visible = true

	music_player.stop()

	if result == "tie":
		win_text.text = "EMPATE!"
		if sound_tie:
			sound_tie.play()
	else:
		win_text.text = "FIM DE JOGO!"
		if sound_win:
			sound_win.play()

# -----------------------------------
# MÚSICA
# -----------------------------------

func play_music():
	if music_player.stream == null:
		var stream = load("res://Assets/music/Who's Ready for Tomorrow (From Cyberpunk 2077) (8-Bit Rat Boy & IBDY Emulation) - 8-Bit Arcade (youtube).mp3")
		if stream:
			music_player.stream = stream
		else:
			print("Erro ao carregar música!")
			return

	if not music_player.playing:
		music_player.play()

func toggle_music():
	if music_player:
		if music_player.playing:
			music_player.stop()
		else:
			music_player.play()
--

func pause():
	if Input.is_action_just_pressed("Pause") or Input.is_action_just_pressed("ui_cancel"):
		game_is_running = false
		var pause_menu_path = "res://Assets/UI/menu/pausemenu.tscn"
		if ResourceLoader.exists(pause_menu_path):
			get_tree().change_scene_to_file(pause_menu_path)
		else:
			print("Cena de pausa não encontrada!", pause_menu_path)

func open_options_menu():
	var options_scene = load("res://Assets/UI/menu/optionsmenu.tscn").instantiate()
	add_child(options_scene)
	options_scene.set_main_scene(self)
