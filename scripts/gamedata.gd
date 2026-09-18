extends Node



var playerpos = Vector2(500,200)
var time = 0000
var trigger_boxes := []
var playerdata := {}
var currentbounds := 0
var encounter := {}
var current_dialogue = "test"
var speaker_name = ""
var portrait = null

const DEFAULT_PATH = "res://data.json"
const USER_PATH = "user://data.json"

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
	},
	{
		"rect": Rect2(Vector2(4000, 50), Vector2(20, 20)),
		"triggered": false,
		"last_trigger_time": 0.0,
		"trigger_position": Vector2.ZERO,
		"daily_reset": -1,
		"reset_time": -1,
		"reset_distance": 200,
		"dialoguefile": "res://jsons/dialogue/tungtung.json",
		"speakername": "",
		"Background": "res://textures/Backgrounds/testbackground.png"
	},
	{
		"rect": Rect2(Vector2(2250, 950), Vector2(20, 20)),
		"triggered": false,
		"last_trigger_time": 0.0,
		"trigger_position": Vector2.ZERO,
		"daily_reset": -1,
		"reset_time": -1,
		"reset_distance": 500,
		"dialoguefile": "res://jsons/dialogue/cave.json",
		"speakername": "",
		"Background": "res://textures/Backgrounds/cave.png"
	}
	]
	
	playerdata = {
		"maxhp": 110,
		"hp": 100,
		"damage": 5, 
		"name": "jeb",
		"damagemod": 0 
	}
	encounter = {
		"hp": 50,
		"name": "gobin",
		"damage": 5,
		"damagemod": 1,
		"png": "",
		"reward": {
			"damagemod" : 1, 
			"maxhealth" : 10
		}
	}
