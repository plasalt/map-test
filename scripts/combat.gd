extends Control

#constants
const DAMAGEEFFECT = preload("res://scenes/damagepop.tscn")

#scene varibles 
@onready var playerhpbar = $player/playerhpbar
@onready var enemyhpbar = $enemy/enemyhpbar
@onready var attackbutton = $menu/attackbutton
@onready var playerattackroll = $player/attackroll
@onready var enemyattackroll = $enemy/attackroll
@onready var clashlabel = $menu/clashmult
@onready var hpplayerlabel = $player/hplabel
@onready var hpenemylabel = $enemy/hplabel
@onready var playerpic = $player/Sprite2D
@onready var enemypic = $enemy/Sprite2D
@onready var explosion = $explosion
@onready var playername = $player/name
@onready var enemyname = $enemy/name


#varibles
var playerroll = 0
var enemyroll = 0 
var playerdamagemod = 5
var enemydamagemod = 0 
var clashmult = 1.0
var damage = 0
var playerbasedamage = 5
var enemybasedamage = 5
var playerhp = 100
var enemyhp = 100
var playermaxhp = 100
var enemymaxhp = 100

func _ready() -> void:
	
	#setting varibles to the data stored in Game data
	playername.text = GameData.playerdata["name"]
	enemyname.text = GameData.encounter["name"]
	playerhp = int(GameData.playerdata["hp"])
	playermaxhp = int(GameData.playerdata["maxhp"])
	playerbasedamage = int(GameData.playerdata["damage"])
	playerdamagemod = int(GameData.playerdata["damagemod"])
	enemyhp = int(GameData.encounter["hp"])
	enemymaxhp = enemyhp
	hpplayerlabel.text = "%d/%d" % [playerhp,playermaxhp]
	hpenemylabel.text = "%d/%d" % [enemyhp,enemymaxhp]
	playerhpbar.value = (float(playerhp) / int(GameData.playerdata["maxhp"]))*100
	enemyhpbar.value = 100
	clashlabel.text = str(clashmult)
	enemydamagemod = int(GameData.encounter["damagemod"])
	enemybasedamage = GameData.encounter["damage"]
	enemypic.texture = load(GameData.encounter["png"])
	pass

#function to apply damage to the player and update the health bar and the display health
func hurtplayer(damage: int ):
	playerhp -= damage
	hpplayerlabel.text = "%d/%d" % [playerhp,playermaxhp]
	playerhpbar.value = (float(playerhp) / playermaxhp)*100
	spawn_damage_popup(damage, playerhpbar.global_position)
	pass

#function to apply damage to the enemy and update the health bar and the display health
func hurtenemy(damage: int):
	enemyhp -= damage
	hpenemylabel.text = "%d/%d" % [enemyhp,enemymaxhp]
	enemyhpbar.value = (float(enemyhp) / enemymaxhp)*100
	spawn_damage_popup(damage, enemyhpbar.global_position)
	pass

#function for when the player wins
func playerwin():
	
	#applies the explosion effect on the enemy
	explosion.position = enemypic.position
	explosion.play("default")
	
	#pauses the script to allow the explosion to play
	await get_tree().create_timer(1.2).timeout
	
	#saves the player hp
	GameData.playerdata["hp"] = playerhp
	
	#opens the winning dialogue file
	#use the writable user:// path instead of res://
	var path = "res://jsons/dialogue/WIN.json"
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()
	var dialogue_data = JSON.parse_string(json_text)
	
	#changes the dialouge to win dialogue to reflect what monster the player killed
	dialogue_data["start"]["text"] = "you killed that %s" % [enemyname.text]
	dialogue_data["reward"]["text"] = "you gained some skills: damagemod + %s, max health + %d" % [int(GameData.encounter["reward"]["damagemod"]),int(GameData.encounter["reward"]["maxhealth"])]
	
	#sets the win dialogue to use as next set of dialogue.
	GameData.current_dialogue = "res://jsons/dialogue/WIN.json"
	
	#adds the rewards to the player stats
	GameData.playerdata["maxhp"] += GameData.encounter["reward"]["maxhealth"]
	GameData.playerdata["damagemod"] += GameData.encounter["reward"]["damagemod"]
	
	#closes and saves the json and adds clean indentations
	var file_write = FileAccess.open(path, FileAccess.WRITE)
	if file_write:
		file_write.store_string(JSON.stringify(dialogue_data, "\t")) 
		file_write.close()
	
	#changes the scene to the dialogue scene to play the updated dialogue 
	get_tree().change_scene_to_file("res://scenes/eventmanager.tscn")

#function for when the player dies 
func playerdeath():
	
	#applies the explosion effect on the player
	explosion.position = playerpic.position
	explosion.play("default")
	
	#pauses the script to allow the explosion to play
	await get_tree().create_timer(1.2).timeout
	
	#opens the winning dialogue file
	#use the writable user:// path instead of res://
	var path = "res://jsons/dialogue/playerdeath.json"
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()
	var dialogue_data = JSON.parse_string(json_text)
	
	#changes the dialouge to death dialogue to reflect what monster killed the player
	dialogue_data["start"]["text"] = "killed by %s" % [enemyname.text]
	
	#sets the next dialogue file to the death dialogue file
	GameData.current_dialogue = "res://jsons/dialogue/playerdeath.json"
	GameData.speaker_name = "death"
	
	#closes and saves the json and adds clean indentations
	var file_write = FileAccess.open(path, FileAccess.WRITE)
	if file_write:
		file_write.store_string(JSON.stringify(dialogue_data, "\t")) 
		file_write.close()
		
	#changes the scene to the dialogue scene to play the updated dialogue 
	get_tree().change_scene_to_file("res://scenes/eventmanager.tscn")

#function to spawn a damage popup notif 
func spawn_damage_popup(amount: int, spawn_pos: Vector2) -> void:
	#checks of damage is more than 0
	if amount <= 0:
		return
	
	#spawns the popup
	var popup = DAMAGEEFFECT.instantiate()
	
	#sets the popup as a child so its infomation can be editied
	get_tree().current_scene.add_child(popup)
	
	#moves the popup to the desired location
	popup.global_position = spawn_pos
	
	#and then applies the animation to the popup 
	popup.animate_damage_popup(amount)

#the main combat function
func _on_attackbutton_button_down() -> void:
	
	#disables the button to start the combat
	attackbutton.disabled = true
	
	#rolls a number for both the player and enemy
	playerroll = randi_range(1,20)
	enemyroll = randi_range(1,20)
	
	#displays the players and enemy's roll along side their damage modifier
	playerattackroll.text = "%s + %d" % [str(playerroll), playerdamagemod]
	enemyattackroll.text = "%s + %d" % [str(enemyroll), enemydamagemod]
	
	#waits for 1 second 
	await get_tree().create_timer(1).timeout
	
	#changes the roll and damage modifier to a combind total
	playerattackroll.text = str(playerroll + playerdamagemod)
	enemyattackroll.text = str(enemyroll + enemydamagemod)
	
	#creates temp varibles for storage
	var dif = ""
	var diffence = 0
	
	#checks who has the higher roll and sets them as the higher roller 
	if  (playerroll + playerdamagemod) >  (enemyroll + enemydamagemod):
		diffence = (playerroll + playerdamagemod) - (enemyroll + enemydamagemod)
		dif = "player"
		pass
	elif  (playerroll + playerdamagemod) <  (enemyroll + enemydamagemod):
		diffence = (enemyroll + enemydamagemod) - (playerroll + playerdamagemod) 
		dif = "enemy"
		pass
	else:
		diffence = 0
		dif = "none"
	
	#matches the higher roller to check if they can hit or it instead go to clash
	match dif:
		#if the higher roll was by the player 
		"player":
			
			#if the player rolls a 20 and the diffece is larger than 5 then it changes damage to a crit
			if playerroll == 20 and diffence > 5: 
				
				#sets the damage to a crit including the clash multiplier
				damage = playerbasedamage*0.4*diffence*clashmult
				print(damage,"player crit")
				
				#updates the clash value
				clashmult = 1.0
				
				#creates a effect to show the increased clash multipler
				spawn_damage_popup(0.5, clashlabel.global_position)
				
			#checks if the diffence is more than five 
			elif diffence > 5:
				
				#sets the damage including the clash multiplier
				damage = playerbasedamage*0.2*diffence*clashmult
				print(damage,"player hit")
				
				#updates the clash value
				clashmult = 1.0
				
				#creates a effect to show the increased clash multipler
				spawn_damage_popup(0.5, clashlabel.global_position)
			
			#if the other check fail that means the value is less than 5 
			else:
				
				#updates the clash value
				clashmult += 0.5
				
				#creates a effect to show the increased clash multipler
				spawn_damage_popup(0.5, clashlabel.global_position)
				print(damage,"player clash")
				
		#if the higher roll was by the enemy 
		"enemy":
			
			#if the enemy rolls a 20 and the diffece is larger than 5 then it changes damage to a crit
			if enemyroll == 20 and diffence > 5: 
				
				#sets the damage to a crit including the clash multiplier
				damage = enemybasedamage*0.4*diffence*clashmult
				print(damage,"enemy crit")
				
				#updates the clash value
				clashmult = 1.0
				
				#creates a effect to show the increased clash multipler
				spawn_damage_popup(0.5, clashlabel.global_position)
				
			#checks if the diffence is more than five 
			elif diffence > 5:
				
				#sets the damage including the clash multiplier
				damage = enemybasedamage*0.2*diffence*clashmult
				print(damage,"enemy hit")
				
				#updates the clash value
				clashmult = 1.0
				
				#creates a effect to show the increased clash multipler
				spawn_damage_popup(0.5, clashlabel.global_position)
				
			#if the other check fail that means the value is less than 5 
			else:
				
				#updates the clash value
				clashmult += 0.5
				
				#creates a effect to show the increased clash multipler
				spawn_damage_popup(0.5, clashlabel.global_position)
				print(damage,"enemy clash")
	
		#if the rolls where tied
		"none":
			
			#checks if both the enemy and player rolled a crit (20s)
			if enemyroll == 20 and playerroll == 20:

				#updates the clash value to a crit clash
				clashmult += 2
				print(damage,"crit clash")
				
				#creates a effect to show the increased clash multipler
				spawn_damage_popup(2, clashlabel.global_position)
			else:
				
				#updates the clash value
				clashmult += 0.5
				print(damage,"clash")
				
				#creates a effect to show the increased clash multipler
				spawn_damage_popup(0.5, clashlabel.global_position)
	pass
	
	#updates the clash label after all the processing 
	clashlabel.text = str(clashmult)
	
	#checks which was the higher roller and matches the damage to the opposition, and checks and passes if the value is invaild
	match dif:
		"player": 
			hurtenemy(damage)
		"enemy":
			hurtplayer(damage)
		_: 
			pass
			
	#sets damage for next round to ensure no damage leaking
	damage = 0
	
	#checks if the player or enemy died and calls its repective functions
	if playerhp <= 0:
		print("player dided")
		playerdeath()
	if enemyhp <= 0: 
		print("enemy slimed") 
		playerwin()
	
	#re-enbles the combat button for the next round of combat
	attackbutton.disabled = false
