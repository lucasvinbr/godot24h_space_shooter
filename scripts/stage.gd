extends Node2D
class_name Stage

const SCREEN_WIDTH : float = 320.0
const SCREEN_HEIGHT : float = 180.0

const ASTEROID_SPAWN_MARGIN : float = 8.0

var is_game_over : bool = false

var asteroid_scene : PackedScene = preload("res://asteroid.tscn")

var score : int = 0

var score_label : Label

var spawn_timer : Timer

func _ready() -> void:
	randomize()
	score_label = $ui/score
	spawn_timer = $spawn_timer
	$player.connect("destroyed", self, "_on_player_destroyed")
	$spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")

func _input(event : InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if is_game_over and Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("res://stage.tscn")
		
func _on_player_destroyed() -> void:
	$ui/retry.show()
	is_game_over = true
	
func _on_spawn_timer_timeout() -> void:
	var new_asteroid : Asteroid = asteroid_scene.instance()
	new_asteroid.position = Vector2(SCREEN_WIDTH + ASTEROID_SPAWN_MARGIN, rand_range(0, SCREEN_HEIGHT))
	new_asteroid.connect("score", self, "_on_player_score")
	new_asteroid.move_speed += score
	add_child(new_asteroid)
	spawn_timer.wait_time *= 0.99
	
func _on_player_score() -> void:
	score += 1
	score_label.text = "Score: " + str(score)