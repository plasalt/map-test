extends Node	

#scene varibles
@export var dialogue_manager: CanvasLayer
@onready var background = $Background

#varibles
var dialogue_lines = GameData.current_dialogue
var speakername = GameData.speaker_name
var Background = load(GameData.trigger_boxes[GameData.currentbounds].Background)


#runs at the start of the this script
func _ready():
	
	#starts the dialogue
	dialogue_manager.start_dialogue(dialogue_lines, speakername)
	
	#sets the background the set background 
	background.texture = Background

#when the dialogue next line button is pressed
func _on_nextline_pressed():
	dialogue_manager.on_button_pressed()

# the change background function
func changebackground(text: String):
	background.texture = load(text)
