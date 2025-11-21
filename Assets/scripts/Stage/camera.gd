extends Camera2D

@onready var players: Array[CharacterBody2D] = [$"../Brawler Girl", $"../Fighter Girl"]

@export var shake_str: float = 0.0
@export var rand_str: float = 1.0
var shake_fd: float = 5.0
var zm_fc: float = 1.0

func _process(delta):
	move()
	zooming()
	if shake_str > 0:
		shake_str = lerpf(shake_str, 0.0, delta * shake_fd)
		offset = Vector2(RandomNumberGenerator.new().randf_range(-shake_str, shake_str), RandomNumberGenerator.new().randf_range(-shake_str, shake_str))
	if zm_fc > 1.0:
		zm_fc = lerpf(zm_fc, 1.0, delta * 10)
		zoom = zoom * zm_fc

func move() -> void:
	var avg: Vector2
	for player in players:
		avg += player.global_position
	avg /= players.size()
	global_position = avg

func zooming() -> void:
	var zoom_factor: float = 1100
	var max_zoom: float = 6
	var longest_dist: float = 0
	for i in players:
		for j in players:
			if i == j: continue
			var dist: float = (i.global_position - j.global_position).length_squared()
			longest_dist = max(longest_dist, dist)
	var z = min(max_zoom, zoom_factor / sqrt(longest_dist))
	zoom = Vector2(z, z)
