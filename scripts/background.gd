extends Sprite

const BG_WIDTH : float = 640.0

var scroll_speed : float = 30.0

func _process(delta : float) -> void:
	position += Vector2.LEFT * scroll_speed * delta
	
	if position.x <= -BG_WIDTH:
		position.x += BG_WIDTH