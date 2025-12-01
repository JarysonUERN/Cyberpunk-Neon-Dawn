extends Control

# --- CONFIGURAÇÃO ---
# Arraste a sua cena de Gameplay (o arquivo .tscn) para este campo no Inspetor
@export var cena_do_jogo: PackedScene 

# Referência ao player de vídeo
@onready var video_player = $VideoStreamPlayer

func _ready():
	# Começa o vídeo assim que a cena abre
	video_player.play()

# Verifica a cada frame se o jogador apertou ENTER ou ESPAÇO para pular
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		iniciar_jogo()

# Essa função será chamada quando o vídeo acabar
func _on_video_stream_player_finished():
	iniciar_jogo()

func iniciar_jogo():
	if cena_do_jogo:
		get_tree().change_scene_to_packed(cena_do_jogo)
	else:
		print("ERRO: Você esqueceu de arrastar a cena do Jogo para o slot")
