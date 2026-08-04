extends CharacterBody2D

@export var step_size := 1
@export var speed := 1000
var target_position : Vector2
var moving := false
@export var clock: Node
@onready var timer = $Timer


func move_to(pos: Vector2):
	target_position = pos
	moving = true
	timer.start()

func stop_move():
	moving = false
	velocity = Vector2.ZERO
	timer.stop

func _on_timer_timeout():

	if !moving:
		timer.stop()
		return

	var direction = global_position.direction_to(target_position)
	var distance = global_position.distance_to(target_position)

	if distance <= step_size:
		global_position = target_position
		moving = false
		timer.stop()
		return
		
	

	velocity = direction * speed
	clock.add_minutes(10)
	move_and_slide()
