extends Camera2D

var speed = 10.0 
var direction : Vector2

func _input(_event):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _process(delta: float) -> void:
	position += direction * speed 
