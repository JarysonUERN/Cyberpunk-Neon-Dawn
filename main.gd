extends Node

# --- REFERÊNCIAS (Arraste os nós para cá no Inspector ou garanta os nomes) ---
@onready var player1 = $"Brawler Girl" # Ajuste o caminho se necessário
@onready var player2 = $"Fighter Girl"
@onready var music_player = $MusicPlayer
@onready var win_text = $CanvasLayer/RichTextLabel
@onready var sound_win = $WinSound
@onready var sound_tie = $TieSound

# Variáveis de Estado
var game_is_running: bool = true
var enable_restart: bool = false

func _ready():
	# Configuração inicial do jogo
	new_game()

func _process(delta):
	# Se o jogo já acabou, verificamos se o jogador quer reiniciar
	if enable_restart:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("restart"):
			# Opção A: Reiniciar a luta
			get_tree().reload_current_scene() 
			# Opção B: Ir para o menu de Game Over (do seu script 1)
			# get_tree().change_scene_to_file("res://Assets/UI/menu/gameover_menu.tscn")
		return

	# Lógica de verificação de vida (Trazida do Script 2)
	check_game_over_conditions()

func new_game():
	game_is_running = true
	enable_restart = false
	win_text.visible = false # Esconde texto de vitória
	
	# Iniciar música (Lógica do Script 1 corrigida)
	play_music()

func check_game_over_conditions():
	# Precisamos acessar a variável 'health' dentro dos scripts das garotas
	# O script 2 assumia que o nó "Health" era filho, aqui assumo que é propriedade do script do personagem
	# Se o "Health" for um nó separado, use: player1.get_node("Health").health
	
	var p1_dead = false
	var p2_dead = false
	
	# Verifique se a variável é 'health' ou se está num nó filho (ajuste conforme seu projeto)
# Acessamos o nó filho "HealthManager" e pegamos a variável health dele
	if player1.get_node("Health").health <= 0:
		p1_dead = true

	if player2.get_node("Health").health <= 0:
		p2_dead = true

	if p1_dead and p2_dead:
		finish_game("tie")
	elif p1_dead or p2_dead:
		finish_game("win")

func finish_game(result: String):
	game_is_running = false
	enable_restart = true
	win_text.visible = true
	
	# Para a música da fase
	music_player.stop()
	
	if result == "tie":
		win_text.text = "EMPATE!" # Ajuste o texto
		if sound_tie: sound_tie.play()
	else:
		win_text.text = "FIM DE JOGO!"
		if sound_win: sound_win.play()

func play_music() -> void:
	# --- CORREÇÃO IMPORTANTE ---
	# O script original tentava carregar o som toda hora. Vamos simplificar.
	if music_player.stream == null:
		# Tenta carregar. Se der erro, verifique o caminho do arquivo.
		var stream = load("res://Assets/music/Who's Ready for Tomorrow (From Cyberpunk 2077) (8-Bit Rat Boy & IBDY Emulation) - 8-Bit Arcade (youtube).mp3")
		if stream:
			music_player.stream = stream
		else:
			print("Erro: Música não encontrada no caminho especificado.")
			return

	if not music_player.playing:
		music_player.play()
