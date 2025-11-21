extends Area2D
signal hit
#sla

@export var speed = 400
@export var player_size : Vector2 = Vector2(50, 50) 

var morto = false
var screen_size
var extents

func _ready():
	screen_size = get_viewport_rect().size
	extents = player_size / 2.0

func _process(delta):
	var velocity = Vector2.ZERO
	
	# --- 1. CAPTURA DE MOVIMENTO ---
	if Input.is_action_pressed("Andar_direita"):
		velocity.x += 1
	if Input.is_action_pressed("Andar_esquerda"):
		velocity.x -= 1
	if Input.is_action_pressed("Pular"):
		velocity.y -= 1
	if Input.is_action_pressed("Abaixar"):
		velocity.y += 1 

	# --- 2. APLICAÇÃO DE MOVIMENTO ---
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	
	# Mantém dentro da tela
	position.x = clamp(position.x, extents.x, screen_size.x - extents.x)
	position.y = clamp(position.y, extents.y, screen_size.y - extents.y)
	
	# --- 3. LÓGICA DE ANIMAÇÃO ---

	# A. Primeiro, verificamos se apertou o botão de ataque AGORA (Just Pressed)
	if Input.is_action_just_pressed("Chutar"):
		$AnimatedSprite2D.play("kick")
	elif Input.is_action_just_pressed("Soco"):
		$AnimatedSprite2D.play("punch")
	elif Input.is_action_just_pressed("Tapa"):
		$AnimatedSprite2D.play("tab")

	# B. AGORA O TRUQUE: Verificamos se um ataque JÁ ESTÁ ACONTECENDO.
	# Se a animação atual for de ataque E estiver tocando, nós paramos a função aqui (return).
	# Isso impede que o código abaixo troque para "walk" ou "idle".
	if $AnimatedSprite2D.is_playing() and $AnimatedSprite2D.animation in ["kick", "punch", "tab"]:
		return 

	# C. Se não estiver atacando, gerenciamos o movimento normal
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
		
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite2D.animation = "jump"
			$AnimatedSprite2D.flip_v = velocity.y > 0
			
	# D. Se estiver parado e não atacando
	else:
		$AnimatedSprite2D.play("idle") 

func _on_body_entered(_body):
	morto = true
	hide() 
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
