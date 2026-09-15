extends Node

@export var text_label = Label
@onready var name_label = $Panel/name
@onready var button = $Button
@onready var choices = $VBoxContainer
@onready var eventmanager = $".."

var typing_speed := 0.025
var current_node_key : String = "start"
var is_typing := false

var file : String
var lines : Dictionary = {}
var active := false

func start_dialogue(dialogue_file: String, speaker_name: String):
	lines = load_json_file(dialogue_file)
	current_node_key = "start"
	active = true
	name_label.text = speaker_name
	show_node()

func show_node():
	var node = lines[current_node_key]
	clear_options()
	
	if node.has("text"):
		await type_line(node["text"])
	
	if node.has("enemy"):
		GameData.encounter = node["enemy"]
	
	
	if node.get("event") == "combat":
		start_combat()
		return
	check_options()
	if node.get("event") == "death":
		deathscreen()
	if node.get("event") == "reward":
		GameData.playerdata["maxhp"] += node["rewards"]["hp"]
		GameData.playerdata["damagemod"] += node["rewards"]["damagemod"]
	if node.get("event") == "heal":
		GameData.playerdata["hp"] += node["heal"]
		print(GameData.playerdata)
		if GameData.playerdata["hp"] > GameData.playerdata["maxhp"]:
			GameData.playerdata["hp"] = GameData.playerdata["maxhp"]  
	if node.get("event") == "background":
		eventmanager.changebackground(node["background"])
		
func type_line(line: String):
	is_typing = true
	text_label.text = ""
	for letter in line:
		if is_typing:
			text_label.text += letter
			await get_tree().create_timer(typing_speed).timeout
		else:
			return
	is_typing = false
	
func check_options():
	var node = lines[current_node_key]
	if node.has("options"):
		for option in node["options"]:
			create_option_button(option["text"], option["target"])
	pass
	
func create_option_button(msg: String, target: String):
	var button = Button.new()
	button.text = msg
	button.pressed.connect(on_option_selected.bind(target))
	choices.add_child(button)
	pass

func on_option_selected(target: String):
	current_node_key = target
	if current_node_key == "end":
		end_dialogue()
	else:
		show_node()

func clear_options():
	for child in choices.get_children():
		child.queue_free()

func on_button_pressed():
	if is_typing:
		is_typing = false
		text_label.text = lines[current_node_key]["text"]
	elif !lines[current_node_key].has("options"):
		current_node_key = lines[current_node_key].get("next", "end")
		if current_node_key == "end":
			end_dialogue()
		else:
			show_node()

func load_json_file(file_path: String):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary or parsed_result is Array:
			print("json loaded")
			print(parsed_result)
			return parsed_result
		else:
			print("Error: Could not parse JSON.")
	else:
		print("Error: File does not exist.")
	

func end_dialogue():
	active = false
	get_tree().change_scene_to_file("res://scenes/control.tscn")

func start_combat():
	
	active = false
	get_tree().change_scene_to_file("res://scenes/combat.tscn")
	print(GameData.encounter)
	pass

func deathscreen():
	active = false
	get_tree().change_scene_to_file("res://scenes/deathscreen.tscn")
	pass
