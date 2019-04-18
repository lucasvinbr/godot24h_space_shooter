extends Area2D
class_name Shot

const SCREEN_WIDTH : float = 320.0
const MOVE_SPEED : float = 500.0
const SHOT_HALFLENGTH : float = 8.0

func _process(delta : float) -> void:
	position += Vector2.RIGHT * MOVE_SPEED * delta
	
	if position.x >= SCREEN_WIDTH + SHOT_HALFLENGTH:
		queue_free()

func _on_shot_area_entered(area : Area2D) -> void:
	if area.is_in_group("asteroid"):
		queue_free()
