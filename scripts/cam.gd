extends Camera2D

var speed = 10.0 
var direction : Vector2

func _input(_event):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _process(delta: float) -> void:
	position += direction * speed 
	print(position)
	if position.y < 300:
		position.y = 300 
	if position.y > 1000:
		position.y = 1000 
	if position.x < 600:
		position.x = 600 
	if position.x > 2700:
		position.x = 2700 

func campos(pos: Vector2):
	position = pos 
