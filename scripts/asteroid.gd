extends Area2D
class_name Asteroid

var explosion_scene : PackedScene = preload("res://explosion.tscn")

var move_speed : float = 100.0

var score_emitted : bool = false

signal score

func _ready() -> void:
	rotation = PI * rand_range(0.0, 2.0)

func _process(delta : float) -> void:
	position += Vector2.LEFT * move_speed * delta

func _on_asteroid_area_entered(area : Area2D) -> void:
	if area.is_in_group("shot") or area.is_in_group("player"):
		if not score_emitted:
			score_emitted = true
			emit_signal("score")
			queue_free()
			
			var stage_node = get_parent()
			var new_explosion = explosion_scene.instance()
			new_explosion.position = position
			stage_node.add_child(new_explosion)
