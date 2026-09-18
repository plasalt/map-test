extends Node2D

#scene varibles
@onready var player = $CharacterBody2D
@onready var marker = $marker
@onready var bounds = $bounds
@onready var cam = $Camera2D
@onready var hp = $CanvasLayer/hp
@onready var hptext = $CanvasLayer/hp/Label
@export var clock: Node
@export var time: Label
@export var cords: Label

#constants
const MARKER = preload("res://scenes/marker.tscn")

# constats
const ARRIVAL_THRESHOLD:  = 10
const click_radius = 19.0

#do when the code first runs 
func _ready():
	
	#sets the player position to the stored position
	player.global_position = GameData.playerpos
	
	#sets the clock to the stored time
	clock.settime(GameData.time)
	
	#sets the cam postition to the player position
	cam.campos(GameData.playerpos)

#function updates every frame
func _process(delta):
	
	#checks if the player is over a trigger box 
	bounds.boundingcheck()
	
	#checks if there are triggers to reset
	bounds.resettriggers()
	
	#updates the player cord to the cords display at the top
	cords.text = str(player.global_position.floor())
	
	#updates the time display to the in game time
	time.text = str(clock.formate_time())
	
	#updates the hp bar so that it displaies the right prencentage of the bar being filled in and the hp out of maxhp 
	hptext.text = "%d/%d" % [GameData.playerdata["hp"],GameData.playerdata["maxhp"]]
	hp.value = (float(GameData.playerdata["hp"]) / GameData.playerdata["maxhp"])*100
	
	#runs the marker check 
	_check_marker_reach()

func _check_marker_reach():
	
	#first checks if there a valid marker 
	if is_instance_valid(marker):
		
		#checks if the player is close enough to the marker with the thershold 
		if player.global_position.distance_to(marker.global_position) <= ARRIVAL_THRESHOLD:
			
			#deletes the marker 
			marker.queue_free()
			
			#stops the player movement
			player.stop_move()

#checks for user inputs
func _input(event):
	
	#check if the user clicks the left mouse button is pressed 
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		#grabs the mouse location after the mouse button was pressed 
		var click_pos = get_global_mouse_position()
		
		#checks if there is a marker already created
		if is_instance_valid(marker):
			
			#if there is this checks if the click was within the radius of the current marker using the click radius constant 
			if click_pos.distance_to(marker.global_position) <= click_radius:
				
				#deletes the curren marker
				marker.queue_free()
				
				#stops the player movement
				player.stop_move()
				return
			
			#if its not within a radius it moves the marker
			else:
				
				#moves the current marker to the click position
				marker.global_position = click_pos
				
				#changes the player move to the click position
				player.move_to(click_pos)
		
		#if a vaild marker already exists 
		else: 
			
			#create a marker
			marker = MARKER.instantiate()
			
			#add the marker as a child so the script can edit the marker values
			add_child(marker)
			
			#set the marker postion to the click position
			marker.global_position = click_pos
			
			#set the player move position to the click position
			player.move_to(click_pos)

#button to exit to main menu
func _on_exit_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
