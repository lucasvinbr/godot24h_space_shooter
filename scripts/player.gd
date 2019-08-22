extends Area2D
class_name Player

const MOVE_SPEED : float = 150.0

const SCREEN_WIDTH : float = 320.0
const SCREEN_HEIGHT : float = 180.0

const SHIP_HALFSIZE : float = 8.0
const SHOT_Y_OFFSET : float = 3.5

var input_dir : Vector2
var stage_node : Node
var shoot_timer : Timer

var shot_scene : PackedScene = preload("res://shot.tscn")
var explode_scene : PackedScene = preload("res://explosion.tscn")

var can_shoot : bool = true

var shotSnd : AudioStreamPlayer

signal destroyed

func _ready() -> void:
	stage_node = get_parent()
	shoot_timer = $reload_timer as Timer
	shotSnd = $shotSnd as AudioStreamPlayer

func _process(delta : float) -> void:
	input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		input_dir.y -= 1.0
	if Input.is_action_pressed("move_down"):
		input_dir.y += 1.0
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1.0
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1.0
	input_dir = input_dir.normalized()
	
	position += input_dir * (MOVE_SPEED * delta)
	
	#position clamping to screen bounds
	if position.x < 0.0 + SHIP_HALFSIZE:
		position.x = 0.0 + SHIP_HALFSIZE
	elif position.x > SCREEN_WIDTH - SHIP_HALFSIZE:
		position.x = SCREEN_WIDTH - SHIP_HALFSIZE
	if position.y < 0.0 + SHIP_HALFSIZE:
		position.y = 0.0 + SHIP_HALFSIZE
	elif position.y > SCREEN_HEIGHT - SHIP_HALFSIZE:
		position.y = SCREEN_HEIGHT - SHIP_HALFSIZE
		
	#shooting!
	if Input.is_action_pressed("fire") && can_shoot:
		shoot()


func shoot() -> void:
	var new_shot_upper : Node = shot_scene.instance()
	var new_shot_lower : Node = shot_scene.instance()
	new_shot_upper.position = position + Vector2(SHIP_HALFSIZE, SHOT_Y_OFFSET)
	new_shot_lower.position = position + Vector2(SHIP_HALFSIZE, -SHOT_Y_OFFSET)
	stage_node.add_child(new_shot_upper)
	stage_node.add_child(new_shot_lower)
	can_shoot = false
	shotSnd.play()
	shoot_timer.start()

func _on_reload_timer_timeout() -> void:
	can_shoot = true


func _on_player_area_entered(area : Area2D) -> void:
	if area.is_in_group("asteroid"):
		queue_free()
		emit_signal("destroyed")
		var player_explosion : Node = explode_scene.instance()
		player_explosion.position = position
		
