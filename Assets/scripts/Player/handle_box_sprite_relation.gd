extends Node

@onready var sprite: AnimatedSprite2D = $"../Sprite"
@export var box_list: Array[Area2D]

func _process(delta: float) -> void:
	if sprite.flip_h == true:
		$"../Shadow".flip_h = true
		$"../Shadow".position.x = 2
		for box in box_list:
			if box.name == "Body":
				(box.get_parent() as Node2D).position.x = 5
			else:
				(box.get_parent() as Node2D).rotation_degrees = -180
	else:
		for box in box_list:
			$"../Shadow".flip_h = false
			$"../Shadow".position.x = -2
			if box.name == "Body":
				(box.get_parent() as Node2D).position.x = 0
			else:
				(box.get_parent() as Node2D).rotation_degrees = 0
