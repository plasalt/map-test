extends Control

@onready var player = $CharacterBody2D
@onready var marker = $marker
@onready var bounds = $bounds
@export var clock: Node

func _ready():
	player.global_position = GameData.playerpos
	clock.settime(GameData.time)
	
	pass


func _process(delta):
	bounds.boundingcheck()
	bounds.resettriggers()
	
	$cords.text = str(player.global_position.floor())
	$time.text = str(clock.formate_time())
	pass

func _input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		var click_pos = get_global_mouse_position()

		marker.global_position = click_pos
		player.target_position = click_pos
		player.move_to(click_pos)
