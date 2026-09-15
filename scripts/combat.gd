extends Control

const damageeffect = preload("res://scenes/damagepop.tscn")

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

var playerroll = 0
var enemyroll = 0 
var playerdamagemod = 5
var enemydamagemod = 0 
var phase = 0
var clashmult = 1.0
var damage = 0
var playerbasedamage = 5
var enemybasedamage = 5
var playerhp = 100
var enemyhp = 100
var playermaxhp = 100
var enemymaxhp = 100

@onready var playername = $player/name
@onready var enemyname = $enemy/name


func _ready() -> void:
	playername.text = GameData.playerdata["name"]
	enemyname.text = GameData.encounter["name"]
	playerhp = int(GameData.playerdata["hp"])
	playermaxhp = int(GameData.playerdata["maxhp"])
	playerbasedamage = int(GameData.playerdata["damage"])
	playerdamagemod = int(GameData.playerdata["damagemod"])
	enemyhp = int(GameData.encounter["hp"])
	enemymaxhp = enemyhp
	print( "%d/%d" % [playerhp,playermaxhp])
	hpplayerlabel.text = "%d/%d" % [playerhp,playermaxhp]
	hpenemylabel.text = "%d/%d" % [enemyhp,enemymaxhp]
	playerhpbar.value = (float(playerhp) / int(GameData.playerdata["maxhp"]))*100
	enemyhpbar.value = 100
	clashlabel.text = str(clashmult)
	enemydamagemod = int(GameData.encounter["damagemod"])
	enemybasedamage = GameData.encounter["damage"]
	enemypic.texture = load(GameData.encounter["png"])
	print(GameData.encounter)
	pass

func hurtplayer(damage: int ):
	playerhp -= damage
	hpplayerlabel.text = "%d/%d" % [playerhp,playermaxhp]
	playerhpbar.value = (float(playerhp) / playermaxhp)*100
	spawn_damage_popup(damage, playerhpbar.global_position)
	pass
	
func hurtenemy(damage: int):
	enemyhp -= damage
	hpenemylabel.text = "%d/%d" % [enemyhp,enemymaxhp]
	enemyhpbar.value = (float(enemyhp) / enemymaxhp)*100
	spawn_damage_popup(damage, enemyhpbar.global_position)
	pass

func playerwin():
	explosion.position = enemypic.position
	explosion.play("default")
	
	GameData.current_dialogue = "res://jsons/dialogue/WIN.json"
	print(GameData.current_dialogue)
	await get_tree().create_timer(1.2).timeout
	GameData.playerdata["hp"] = playerhp
	var path = "res://jsons/dialogue/WIN.json"
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()
	var dialogue_data = JSON.parse_string(json_text)
	dialogue_data["start"]["text"] = "you lowk slimed that %s" % [enemyname.text]
	dialogue_data["reward"]["text"] = "you gained some skills: damagemod + %s, max health + %d" % [int(GameData.encounter["reward"]["damagemod"]),int(GameData.encounter["reward"]["maxhealth"])]
	dialogue_data["reward"]["rewards"]["hp"] = 0
	dialogue_data["reward"]["rewards"]["damagemod"] = 0
	GameData.playerdata["maxhp"] += GameData.encounter["reward"]["maxhealth"]
	GameData.playerdata["damagemod"] += GameData.encounter["reward"]["damagemod"]
	var file_write = FileAccess.open(path, FileAccess.WRITE)
	if file_write:
		file_write.store_string(JSON.stringify(dialogue_data, "\t")) 
		file_write.close()
	get_tree().change_scene_to_file("res://scenes/eventmanager.tscn")
	pass

func playerdeath():
	explosion.position = playerpic.position
	explosion.play("default")
	await get_tree().create_timer(1.2).timeout
	GameData.current_dialogue = "res://jsons/dialogue/playerdeath.json"
	GameData.speaker_name = "death"
	print(GameData.current_dialogue)
	var path = "res://jsons/dialogue/playerdeath.json"
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()
	var dialogue_data = JSON.parse_string(json_text)
	dialogue_data["start"]["text"] = "killed by %s" % [enemyname.text]
	var file_write = FileAccess.open(path, FileAccess.WRITE)
	if file_write:
		file_write.store_string(JSON.stringify(dialogue_data, "\t")) 
		file_write.close()
	get_tree().change_scene_to_file("res://scenes/eventmanager.tscn")
	pass



func spawn_damage_popup(amount: int, spawn_pos: Vector2) -> void:
	if amount <= 0:
		return
	
	var popup = damageeffect.instantiate()
	get_tree().current_scene.add_child(popup)
	popup.global_position = spawn_pos
	popup.animate_damage_popup(amount)



func _on_attackbutton_button_down() -> void:
	attackbutton.disabled = true
	phase = 0
	playerroll = randi_range(1,20)
	enemyroll = randi_range(1,20)
	playerattackroll.text = "%s + %d" % [str(playerroll), playerdamagemod]
	enemyattackroll.text = "%s + %d" % [str(enemyroll), enemydamagemod]
	await get_tree().create_timer(1).timeout
	phase = 1 
	playerattackroll.text = str(playerroll + playerdamagemod)
	enemyattackroll.text = str(enemyroll + enemydamagemod)
	phase = 2
	
	var dif = ""
	var diffence = 0
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
	
	print(playerroll)
	print(enemyroll)
	match dif:
		"player":
			if playerroll == 20 and diffence > 5: 
				damage = playerbasedamage*0.4*diffence*clashmult
				print(damage,"player crit")
				clashmult = 1.0
				clashlabel.text = str(clashmult)
			elif diffence > 5:
				damage = playerbasedamage*0.2*diffence*clashmult
				print(damage,"player hit")
				clashmult = 1.0
				clashlabel.text = str(clashmult)
			else:
				clashmult += 0.5
				spawn_damage_popup(0.5, clashlabel.global_position)
				print(damage,"player clash")
		"enemy":
			if enemyroll == 20 and diffence > 5: 
				damage = enemybasedamage*0.4*diffence*clashmult
				print(damage,"enemy crit")
				clashmult = 1.0
				clashlabel.text = str(clashmult)
			elif diffence > 5:
				damage = enemybasedamage*0.2*diffence*clashmult
				print(damage,"enemy hit")
				clashmult = 1.0
				clashlabel.text = str(clashmult)
			else:
				clashmult += 0.5
				spawn_damage_popup(0.5, clashlabel.global_position)
				print(damage,"enemy clash")
			pass
		"none":
			if enemyroll == 20 and playerroll == 20:
				clashmult += 2
				print(damage,"crit clash")
				spawn_damage_popup(2, clashlabel.global_position)
			else:
				clashmult += 0.5
				print(damage,"clash")
				spawn_damage_popup(0.5, clashlabel.global_position)
	pass
	clashlabel.text = str(clashmult)
	phase = 3
	match dif:
		"player": 
			hurtenemy(damage)
		"enemy":
			hurtplayer(damage)
		_: 
			pass
	damage = 0
	
	phase = 4
	if playerhp <= 0:
		print("player dided")
		playerdeath()
	if enemyhp <= 0: 
		print("enemy slimed") 
		playerwin()
	
	
	attackbutton.disabled = false
