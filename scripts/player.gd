extends CharacterBody2D

#scene varibles 
@export var step_size := 1
@export var speed := 1000
@export var clock: Node
@onready var timer = $Timer

#varibles
var target_position : Vector2
var moving := false

#starts the moving function by giving the player a location to move to 
func move_to(pos: Vector2):
	target_position = pos
	moving = true
	timer.start()

#stops the player from moving
func stop_move():
	moving = false
	velocity = Vector2.ZERO
	timer.stop()

#called periodically by the Timer to handle step-by-step movement logic
func _on_timer_timeout():
	
	#if the movement has been cancelled stop the timer and exit
	if !moving:
		timer.stop()
		return
	
	#calculate the direction and distance from the player 
	var direction = global_position.direction_to(target_position)
	var distance = global_position.distance_to(target_position)

	#check if the distance is less than the step size and if so stop moving 
	if distance <= step_size:
		global_position = target_position
		moving = false
		timer.stop()
		return
		
	
	#move the player based off the player speed and add time to clock
	velocity = direction * speed
	clock.add_minutes(10)
	move_and_slide()
