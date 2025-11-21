extends Node

@export var mob_scene: PackedScene
var score

# Chamado quando o nó entra na árvore da cena pela primeira vez.
func _ready():
	# Opcional: Tocar música assim que o jogo abre?
	# play_music() 
	new_game()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	# Trocamos de cena para o Menu de Game Over
	# Certifique-se de que o caminho do arquivo está exato!
	get_tree().change_scene_to_file("res://Assets/UI/menu/gameover_menu.tscn")

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	play_music() # Inicia a música quando o jogo começa

func play_music() -> void:
	# Se você não tiver um nó AudioStreamPlayer chamado "MusicPlayer", isso dará erro.
	# Certifique-se de criar o nó na cena Main.
	if has_node("MusicPlayer"):
		var music_player = $MusicPlayer
		if music_player.stream == null:
			music_player.stream = load("res://Assets/music/Who's Ready for Tomorrow (From Cyberpunk 2077) (8-Bit Rat Boy & IBDY Emulation) - 8-Bit Arcade (youtube).mp3")
		
		# --- CORREÇÃO AQUI ---
		# Antes estava 'play_music()' (chamava a função de novo -> loop infinito)
		# Agora chamamos o método .play() do nó de áudio.
		if not music_player.playing:
			music_player.play()
	else:
		print("Aviso: Nó 'MusicPlayer' não encontrado na cena Main.")

func _on_score_timer_timeout():
	score += 1

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout():
	# Criar uma nova instância da cena Mob.
	var mob = mob_scene.instantiate()

	# Escolher uma localização aleatória no Path2D.
	# NOTA: Se você deletou o MobPath para fazer a "linha reta", 
	# este código vai dar erro. Se o MobPath ainda existe, vai funcionar.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Definir a posição do mob para a localização aleatória.
	mob.position = mob_spawn_location.position

	# Definir a direção do mob perpendicular à direção do caminho.
	var direction = mob_spawn_location.rotation + PI / 2

	# Adicionar um pouco de aleatoriedade à direção.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Escolher a velocidade para o mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# "Spawnar" o mob adicionando-o à cena Main.
	add_child(mob)

# 'delta' é o tempo decorrido desde o frame anterior.
func _process(delta: float) -> void:
	pass

# Esta função precisa estar conectada ao sinal 'hit' do Player!
func _on_player_hit() -> void:
	# Verifica se o jogador morreu (baseado na variável do script do Player)
	if $Player.morto == true:
		game_over()
