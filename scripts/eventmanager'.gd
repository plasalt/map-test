extends Node	

@export var dialogue_manager: CanvasLayer

var dialogue_lines = GameData.trigger_boxes[GameData.currentbounds].dialoguefile



func _ready():
	print(GameData.currentbounds)
	print(dialogue_lines)
	dialogue_manager.start_dialogue(dialogue_lines, "john")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/control.tscn")
	pass

func _on_nextline_pressed():
	dialogue_manager.on_button_pressed()
