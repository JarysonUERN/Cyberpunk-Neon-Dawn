extends Area2D
signal hit

@export var speed = 400
@export var player_size : Vector2 = Vector2(50, 50) 

var screen_size
var extents # "Meio-tamanho" do jogador

func _ready():
	screen_size = get_viewport_rect().size
	
	# MUDANÇA: Agora usamos a variável 'player_size' que você definiu
	# em vez de tentar adivinhar o tamanho pela colisão.
	extents = player_size / 2.0


func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("Andar_direita"):
		velocity.x += 1
	if Input.is_action_pressed("Andar_esquerda"):
		velocity.x -= 1
	if Input.is_action_pressed("Pular"):
		velocity.y -= 1
	if Input.is_action_pressed("Abaixar"):
		velocity.y += 1 # <-- CORREÇÃO APLICADA AQUI

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	
	# O clamp agora usa o 'extents' vindo da 'player_size'
	position.x = clamp(position.x, extents.x, screen_size.x - extents.x)
	position.y = clamp(position.y, extents.y, screen_size.y - extents.y)
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "jump"
		# Esta linha já vai funcionar para "Abaixar" (vai inverter a animação)
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	# A LINHA 'hide()' FOI REMVIDA DAQUI


# Esta função está CORRETA. Ela esconde o jogador QUANDO ele é atingido.
func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

# Esta função está CORRETA. Ela mostra o jogador quando o jogo (re)começa.
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
