extends Camera2D

#varibles
var speed = 10.0 
var direction : Vector2

#function to get the user input and convert them into a direction
func _input(_event):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

#main updating function
func _process(delta: float) -> void: 
	#updates the cameras positions based of user input
	position += direction * speed
	
	#clamps the camera's position to ensure that the user doesnt go out of bounds
	if position.y < 300:
		position.y = 300 
	if position.y > 1000:
		position.y = 1000 
	if position.x < 600:
		position.x = 600 
	if position.x > 2700:
		position.x = 2700 

#function to manually change the camera position outside of this script
func campos(pos: Vector2):
	position = pos 
