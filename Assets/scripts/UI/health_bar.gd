extends ProgressBar

# Referência ao nó filho. O nome no Scene Tree DEVE ser exatamente "DamageBar"
@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer

var health: int = 0 : set = _set_health

func _set_health(new_health: int) -> void:
	var prev_health: int = health
	health = min(max_value, new_health)
	value = health
	
	# Guard Clause: Se o jogo tentar atualizar a vida antes do nó DamageBar existir,
	# encerramos a função para evitar o crash (Null Pointer Exception).
	if damage_bar == null:
		return

	if health < prev_health:
		# Se tomou dano, iniciamos o timer para o efeito de "atraso" na barra secundária
		timer.start()
	else:
		# Se curou, a barra de dano sobe junto imediatamente
		damage_bar.value = health

func _init_health(_health) -> void:
	health = _health
	max_value = health
	value = health
	
	# --- CORREÇÃO DO ERRO ---
	# Se esta função for chamada antes do _ready() (comum ao instanciar via código),
	# o damage_bar ainda seria 'null'. O 'await ready' pausa a execução aqui
	# até que todos os nós filhos (@onready) estejam carregados.
	if not is_inside_tree():
		await ready
	
	if damage_bar:
		damage_bar.max_value = health
		damage_bar.value = health

func _on_timer_timeout():
	# Sincroniza a barra de dano com a vida atual após o tempo passar
	if damage_bar:
		damage_bar.value = health
