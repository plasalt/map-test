extends Control

#scene varibles
@onready var backmenu = $Button

#when the button backmenu is pressed the scene will switch to the mainmeun scene
func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
