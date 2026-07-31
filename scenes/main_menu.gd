extends Control

@export var button: Button

@onready var target_x 


func _process(delta: float) -> void:
	if button.is_hovered():
		target_x = 0.0
	else:
		target_x = -15.0
	button.position.x = lerp(button.position.x, target_x, 0.3)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control.tscn")
	pass # Replace with function body.
