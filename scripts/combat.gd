extends Control
@onready var playerhpbar = $player/playerhpbar
@onready var enemyhpbar = $enemy/enemyhpbar
@onready var attackbutton = $menu/attackbutton
@onready var playerattackroll = $player/attackroll
@onready var enemyattackroll = $enemy/attackroll
@onready var clashlabel = $menu/clashmult
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
	print(GameData.playerdata["hp"])
	pass



func _process(delta: float) -> void:
	pass

func hurtplayer(damage: int ):
	playerhpbar.value -= damage
	pass
	
func hurtenemy(damage: int ):
	enemyhpbar.value -= damage
	pass

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
	
	match dif:
		"player":
			if playerroll == 20 and diffence > 5: 
				damage = playerbasedamage*0.2*diffence*clashmult
			elif playerroll > 5:
				damage = playerbasedamage*0.1*diffence*clashmult
			else:
				clashmult += 0.2
		"enemy":
			if enemyroll == 20 and diffence > 5: 
				damage = enemybasedamage*0.2*diffence*clashmult
			elif enemyroll > 5:
				damage = enemybasedamage*0.1*diffence*clashmult
			else:
				clashmult += 0.2
			pass
		"none":
			if enemyroll == 20 & playerroll == 20:
				clashmult += 2
			else:
				clashmult += 0.5
	pass
