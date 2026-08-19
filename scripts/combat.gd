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



var playerroll = 0
var enemyroll = 0 
var playerdamagemod = 0
var enemydamagemod = 0 
var phase = 0
var clashmult = 1.0
var damage = 0
var playerbasedamage = 5
var enemybasedamage = 5


func _ready() -> void:
	print(GameData.playerdata["hp"], "player hp")
	hpplayerlabel.text = str(GameData.playerdata["hp"])
	hpenemylabel.text = str(100)
	pass



func _process(delta: float) -> void:
	pass

func hurtplayer(damage: int ):
	playerhpbar.value -= damage
	hpplayerlabel.text = str(int(playerhpbar.value))
	spawn_damage_popup(damage, playerhpbar.global_position)
	pass
	
func hurtenemy(damage: int):
	enemyhpbar.value -= damage
	hpenemylabel.text = str(int(enemyhpbar.value))
	spawn_damage_popup(damage, enemyhpbar.global_position)
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
				print(damage,"enemy hit")
			pass
		"none":
			if enemyroll == 20 and playerroll == 20:
				clashmult += 2
				print(damage,"crit clash")
			else:
				clashmult += 0.5
				print(damage,"clash")
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
	attackbutton.disabled = false
