extends Node

#scene varibles
@export var text_label = Label
@onready var name_label = $Panel/name
@onready var button = $Button
@onready var choices = $VBoxContainer
@onready var eventmanager = $".."

#varibles
var current_node_key : String = "start"
var is_typing := false
var file : String
var lines : Dictionary = {}
var active := false

#constants
const  typing_speed := 0.025

#start dialogue function
func start_dialogue(dialogue_file: String, speaker_name: String):
	
	#loads the dialogue from a json
	lines = load_json_file(dialogue_file)
	
	#sets the starting node to first node (start)
	current_node_key = "start"
	
	#sets the dialogue to active
	active = true
	
	#sets the speaker label to the name of the speaker
	name_label.text = speaker_name
	
	#shows the first node
	show_node()

#show node function
func show_node():
	
	#grabs the dialogue from the first node
	var node = lines[current_node_key]
	
	#clears the option box
	clear_options()
	
	#checks if the node has text to display and if it does it types out the text 
	if node.has("text"):
		await type_line(node["text"])
	
	#checks if the node has enemy infomation and if it does it pushs the data to the game data
	if node.has("enemy"):
		GameData.encounter = node["enemy"]
	
	#checks if the node has a combat event
	if node.get("event") == "combat":
		
		#starts combat 
		start_combat()
	
	#checks if the node have a death event
	if node.get("event") == "death":
		
		#kills the player and shows the death screen
		deathscreen()
		
	#checks if the node has a reward event 
	if node.get("event") == "reward":
		
		#applied the rewards from the nodes rewards values
		GameData.playerdata["maxhp"] += node["rewards"]["hp"]
		GameData.playerdata["damagemod"] += node["rewards"]["damagemod"]
		
	#checks if the node have a heal event
	if node.get("event") == "heal":
		
		#applies the healing from the node's heal value
		GameData.playerdata["hp"] += node["heal"]
		
		#checks if the player hp is higher than max hp to prevent overhealing
		if GameData.playerdata["hp"] > GameData.playerdata["maxhp"]:
			
			#if so, sets the player hp to the max hp 
			GameData.playerdata["hp"] = GameData.playerdata["maxhp"]  
	
	#checks if the node has a background event 
	if node.get("event") == "background":
		
		#script talks the the event manage and pushes the background to change to
		eventmanager.changebackground(node["background"])
	
	#checks for option in the dialogue
	check_options()
	
#function to type out the dialogue in the type writter fasion
func type_line(line: String):
	
	#sets the typing statment to true
	is_typing = true
	
	#sets the desplay text to empty
	text_label.text = ""
	
	# for each of the letters in the dialogue line
	for letter in line:
		
		#check if is_typing is true
		if is_typing:
			
			#adds a letter to the dialogue display
			text_label.text += letter
			
			#waits the time set in the varible
			await get_tree().create_timer(typing_speed).timeout
		
		#if istyping is false	
		else:
			
			#skip
			return
	
	#set is type to false to end the typing phase
	is_typing = false

#function to check optiions	
func check_options():
	
	#grab the node data
	var node = lines[current_node_key]
	
	#check if the node has options
	if node.has("options"):
		
		#creates a option for each option in dialogue 
		for option in node["options"]:
			create_option_button(option["text"], option["target"])
	pass

#creates a button for the options
func create_option_button(msg: String, target: String):
	
	#creates a new button
	var button = Button.new()
	
	#sets the button text to the option text 
	button.text = msg
	
	#sets so when the button is press its linked to the right option
	button.pressed.connect(on_option_selected.bind(target))
	
	#adds the button to the containter so the values are modifiable 
	choices.add_child(button)
	pass

#checks what the options is binded to 
func on_option_selected(target: String):
	
	#changed the node to the binded key
	current_node_key = target
	
	#if the current key is end
	if current_node_key == "end":\
	
		#end the dialogue
		end_dialogue()
	
	#else it contiunes to the next dialogue 
	else:
		show_node()

#clears the old options 
func clear_options():
	for child in choices.get_children():
		child.queue_free()

#button to skip text
func on_button_pressed():
	
	#checks if the text is current being typed 
	if is_typing:
		
		#sets the typing mode to false 
		is_typing = false
		
		#auto completes the text so the user can skip the typing
		text_label.text = lines[current_node_key]["text"]
	
	#if text is not typing
	elif !lines[current_node_key].has("options"):
		
		#checks if the next node is a end
		current_node_key = lines[current_node_key].get("next", "end")
		
		#if it is end the dialogue 
		if current_node_key == "end":
			end_dialogue()
			
		#else contiune the dialogue
		else:
			show_node()

#function to load the dialogue data from json 
func load_json_file(file_path: String):
	
	#checks for file access
	if FileAccess.file_exists(file_path):
		
		#loads the file to storage 
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		
		#parses the file into a readable formate for the script to use
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		#checks if the json can be prased propely
		if parsed_result is Dictionary or parsed_result is Array:
			print("json loaded")
			return parsed_result
			
		#ERROR if the prase doesnt work
		else:
			print("Error: Could not parse JSON.")
	
	#ERROR if the file doesnt exist
	else:
		print("Error: File does not exist.")
	
#ends the dialogue and changes the scene back to the main map 
func end_dialogue():
	active = false
	get_tree().change_scene_to_file("res://scenes/control.tscn")

#starts the combat and changes the scene to the combat scene 
func start_combat():
	active = false
	get_tree().change_scene_to_file("res://scenes/combat.tscn")
	print(GameData.encounter)
	pass

#starts the deathscreen and change the scene to the death scene
func deathscreen():
	active = false
	get_tree().change_scene_to_file("res://scenes/deathscreen.tscn")
	pass
