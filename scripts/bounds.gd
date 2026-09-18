extends Node2D

class_name Triggersystem

#scene varibles 
@export var player = CharacterBody2D
@export var clock: Node

#varibles
var triggers: Array[bool] = []

#constants
const  reset_time_default =  10
const  reset_distance_default = 10
const  reset_daily_default = 1200


#claases
class BoxTrigger:
	
	#stores 2 vector2 to form a rectangle with a location and a size 
	var rect: Rect2
	
	#check if the boxtrigger has been triggered
	var triggered := false
	
	#when the boxtrigger was last triggered
	var last_trigger_time := 0.0
	
	#check where the boxtrigged was triggered at 
	var trigger_position := Vector2.ZERO
	
	#checks if the trigger should reset during the day
	var daily_reset := -1
	
	#checks if the trigger should reset after some time
	var reset_time := -1.0
	
	#check how far the player should be before the trigger resets
	var reset_distance := -1.0
	
	#checks if there is dialogue
	var dialogue := true
	
	#dialouge file to use
	var dialoguefile := ""
	
	#the speaker of the dialogue
	var speakername := ""
	
	#what background the trigger should use
	var Background := ""

#array of class boxtrigger
var boxes: Array[BoxTrigger] = []

#runs at the start of runtime
func _ready():
	
	#loads all the triggers from game data 
	load_triggers_from_gamedata()

#creates a new Boxtrigger object using the boxtrigger class
func createboundingbox(rect: Rect2, reset_time := -1.0, reset_distance := -1.0, daily_reset := -1 ):
	
	#creates a boxtrigger object
	var p := BoxTrigger.new()
	
	#sets all the boxtrigger data using the data inputed in the function
	p.rect = rect
	p.reset_time = reset_time
	p.reset_distance = reset_distance
	p.daily_reset = daily_reset
	
	#adds it to the array of boxtriggers
	boxes.append(p)
	



#function to check if the player is on top of a box trigger
func boundingcheck():
	
	#go through all the boxes in the boxtrigger array 
	for i in boxes.size():
		
		#takes one of them to check
		var p := boxes[i]
		
		#checks if the players base point is over the rect of the boxtrigger 
		if p.rect.has_point(player.global_position.floor()) and !p.triggered:
			firetrigger(i,p)
			
#fires the trigger selected
func firetrigger(id : int, p : BoxTrigger):
	
	#sets the trigger state to trigged
	p.triggered = true
	
	#sets when the trigger was last triggered
	p.last_trigger_time = clock.get_time_minutes()
	
	#sets where it was triggered from
	p.trigger_position = player.global_position.floor()
	
	#saves the player data, time data and pushes the dialogue data to gamedata
	GameData.playerpos = player.global_position.floor()
	GameData.time = clock.get_time_minutes()
	GameData.current_dialogue = p.dialogue
	GameData.currentbounds = id
	GameData.current_dialogue = GameData.trigger_boxes[GameData.currentbounds].dialoguefile
	GameData.speaker_name = GameData.trigger_boxes[GameData.currentbounds].speakername
	
	#function to save trigger states to game data
	save_triggers_to_gamedata()
	
	#changes the scene to the event manager/ dialouge player 
	get_tree().change_scene_to_file("res://scenes/eventmanager.tscn")
	
#function to save trigger states to game data
func save_triggers_to_gamedata():
	#first clears the triggers stored to make sure that no dupes are present 
	GameData.trigger_boxes.clear()
	
	#loops through all the triggers in the array and appends all their data to a array in game data
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

#function to load triggers from gamedata
func load_triggers_from_gamedata():
	
	#checks if the gamedata array for triggers and if it is skips the rest of the function
	if GameData.trigger_boxes.is_empty():
		return
	
	#clears the trigger box array to ensure no remaining data is stored
	boxes.clear()
	
	#this function goes through all the data in gamedata.trigger_boxes and appended to the box trigger array to load them in the array
	for data in GameData.trigger_boxes:
		
		#first it creates a boxtrigger object to load all the infomation to 
		var p := BoxTrigger.new()
		
		#loads all the data to the new object
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
		
		#adds it too the array once all the data is loaded
		boxes.append(p)

#function to reset all resetable triggers when the conditions are met
func resettriggers():
	
	#loads the current time to a varible
	var now := int(clock.get_time_minutes())
	
	#loads the day time to a varible
	var daycycle := int(clock.get_time())
	
	#loops through all the triggers
	for p in boxes:
		
		#first checks if the trigger is triggered and if not it exits the loop for the current trigger box it is checking
		if !p.triggered:
			continue
			
		#checks if the box trigger has a valid time_limit trigger that being any number over 0 and -1 else it overwrite it to the reset time default
		var time_limit = p.reset_time if p.reset_time > 0 or p.reset_time == -1 else reset_time_default
		
		#checks if the box trigger has a dist_limit trigger that being any number over 0 and -1 else it overwrite it to the reset distance default
		var dist_limit = p.reset_distance if p.reset_distance > 0 or p.reset_distance == -1 else reset_distance_default
		
		#checks if the box trigger has a daily_limit trigger that being any number over 0 and -1 else it overwrite it to the reset daily default
		var daily_limit = p.daily_reset if p.daily_reset > 0000 or p.daily_reset == -1 else reset_daily_default
		
		#checks if there has been enough time has passed, and checks if time limit, the limit is enabled (!= -1) and it doesn't conflict with the day cycle
		var time_passed = now - p.last_trigger_time > time_limit and time_limit != -1 and time_limit != daycycle
		
		#check if the player is far enough from the trigger location to reset, and checks if the limit is enabled (!= -1) 
		var far_enough = player.global_position.floor().distance_to(p.trigger_position) > dist_limit and dist_limit != -1
		
		#checks if the day time is the same as the trigger reset time and checks if limit is enabled (!= -1) 
		var daytime_correct = daycycle == daily_limit and daily_limit != -1
		
		#if any of these varibles are true and if they are it fires a trigger reset for the current trigger 
		if time_passed or far_enough or daytime_correct:
			p.triggered = false

#function to manually reset the trigger in case of special situtations
func manualtriggerreset(id: int):
	boxes[id].triggered = false
	pass


func _draw():
	for p in boxes:
		draw_rect(p.rect, Color(0, 0, 1, 0.3), true)
		draw_rect(p.rect, Color.BLUE, false)
	
	

	
