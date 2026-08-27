extends Node	

@export var dialogue_manager: CanvasLayer
@onready var background = $Background

var dialogue_lines = GameData.current_dialogue
var speakername = GameData.speaker_name
var Background = load(GameData.trigger_boxes[GameData.currentbounds].Background)



func _ready():
	print(GameData.currentbounds)
	print(dialogue_lines)
	dialogue_manager.start_dialogue(dialogue_lines, speakername)
	print(Background)
	background.texture = Background


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/control.tscn")
	pass

func _on_nextline_pressed():
	dialogue_manager.on_button_pressed()
