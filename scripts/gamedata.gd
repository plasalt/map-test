extends Node



var playerpos = Vector2.ZERO
var time = 0000
var trigger_boxes := []
var currentbounds := 0



var current_dialogue = "test"
var speaker_name = ""
var portrait = null

func _ready():
	trigger_boxes = [
	{
		"rect": Rect2(Vector2(1000, 100), Vector2(200, 150)),
		"triggered": false,
		"last_trigger_time": 0.0,
		"trigger_position": Vector2.ZERO,
		"daily_reset": -1,
		"reset_time": -1,
		"reset_distance": 200,
		"dialoguefile": "res://jsons/dialogue/john.json",
		"speakername": "test",
		"Background": "res://textures/Backgrounds/Background1.png"
		
	},
	{
		"rect": Rect2(Vector2(100, 100), Vector2(100, 100)),
		"triggered": false,
		"last_trigger_time": 0.0,
		"trigger_position": Vector2.ZERO,
		"daily_reset": -1,
		"reset_time": -1,
		"reset_distance": 200,
		"dialoguefile": "res://jsons/dialogue/startingzone.json",
		"speakername": "test",
		"Background": "res://textures/Backgrounds/Background1.png"
	}
]
	pass
