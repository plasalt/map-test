extends Control

#scene varibles
@onready var button = $Button

#when this button pressed switch scene to the main map
func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/control.tscn")
