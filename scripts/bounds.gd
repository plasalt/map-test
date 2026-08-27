extends Node
class_name Triggersystem

@export var player = CharacterBody2D
@export var clock: Node


var triggers: Array[bool] = []

#defaults
const  reset_time_default =  10
const  reset_distance_default = 10
const  rest_daily_default = 1200



class BoxTrigger:
	var rect: Rect2
	var triggered := false
	var last_trigger_time := 0.0
	var trigger_position := Vector2.ZERO
	var daily_reset := -1
	var reset_time := -1.0
	var reset_distance := -1.0
	var dialogue := true
	var dialoguefile := ""
	var speakername := ""
	var Background := ""
	
var boxes: Array[BoxTrigger] = []


func _ready():
	
	load_triggers_from_gamedata()

func createboundingbox(rect: Rect2, reset_time := -1.0, reset_distance := -1.0, daily_reset := -1 ):
	var p := BoxTrigger.new()
	p.rect = rect
	p.reset_time = reset_time
	p.reset_distance = reset_distance
	p.daily_reset = daily_reset
	boxes.append(p)
	




func boundingcheck():
	for i in boxes.size():
		var p := boxes[i]
		
		if p.rect.has_point(player.global_position.floor()) and !p.triggered:
			firetrigger(i,p)
			
func firetrigger(id : int, p : BoxTrigger):
	print("trigger fired"," ",id)
	p.triggered = true
	p.last_trigger_time = clock.get_time_minutes()
	p.trigger_position = player.global_position.floor()
	
	
	GameData.playerpos = player.global_position.floor()
	GameData.time = clock.get_time_minutes()
	GameData.current_dialogue = p.dialogue
	GameData.currentbounds = id
	GameData.current_dialogue = GameData.trigger_boxes[GameData.currentbounds].dialoguefile
	GameData.speaker_name = GameData.trigger_boxes[GameData.currentbounds].speakername
	save_triggers_to_gamedata()
	
	
	get_tree().change_scene_to_file("res://scenes/eventmanager.tscn")
	

func save_triggers_to_gamedata():
	GameData.trigger_boxes.clear()

	for p in boxes:
		GameData.trigger_boxes.append({
			"rect": p.rect,
			"triggered": p.triggered,
			"last_trigger_time": p.last_trigger_time,
			"trigger_position": p.trigger_position,
			"daily_reset": p.daily_reset,
			"reset_time": p.reset_time,
			"reset_distance": p.reset_distance,
			"dialogue": p.dialogue,
			"dialoguefile": p.dialoguefile,
			"speakername": p.speakername,
			"Background": p.Background
		})

func load_triggers_from_gamedata():
	if GameData.trigger_boxes.is_empty():
		return

	boxes.clear()

	for data in GameData.trigger_boxes:
		var p := BoxTrigger.new()

		p.rect = data.rect
		p.triggered = data.triggered
		p.last_trigger_time = data.last_trigger_time
		p.trigger_position = data.trigger_position
		p.daily_reset = data.daily_reset
		p.reset_time = data.reset_time
		p.reset_distance = data.reset_distance
		p.dialoguefile = data.dialoguefile
		p.speakername = data.speakername 
		p.Background = data.Background

		boxes.append(p)


func resettriggers():
	var now := int(clock.get_time_minutes())
	var daycycle := int(clock.get_time())
	for p in boxes:
		if !p.triggered:
			continue
		var time_limit = p.reset_time if p.reset_time > 0 or p.reset_time == -1 else reset_time_default
		var dist_limit = p.reset_distance if p.reset_distance > 0 or p.reset_distance == -1 else reset_distance_default
		var daily_limit = p.daily_reset if p.daily_reset > 0000 or p.daily_reset == -1 else reset_distance_default

		var time_passed = now - p.last_trigger_time > time_limit and time_limit != -1 and time_limit != daycycle
		var far_enough = player.global_position.floor().distance_to(p.trigger_position) > dist_limit and dist_limit != -1
		var daytime_correct = daycycle == daily_limit and daily_limit != -1
		
		if time_passed or far_enough or daytime_correct:
			p.triggered = false
			print("trigger reset",p,time_passed,far_enough,daytime_correct)
			
func manualtriggerreset(id: int):
	boxes[id].triggered = false
	pass
	

	
