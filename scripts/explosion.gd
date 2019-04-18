extends AnimatedSprite

func _ready() -> void:
	rotation = PI * rand_range(0.0, 2.0)
	playing = true