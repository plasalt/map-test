extends Node2D

@onready var player = $CharacterBody2D
@onready var marker = $marker
@onready var bounds = $bounds
@onready var cam = $Camera2D
@onready var hp = $CanvasLayer/hp
@onready var hptext = $CanvasLayer/hp/Label
@export var clock: Node
@export var time: Label
@export var cords: Label
const Marker = preload("res://scenes/marker.tscn")

# Set the distance threshold (in pixels) for reaching the marker
const ARRIVAL_THRESHOLD:  = 10

func _ready():
	player.global_position = GameData.playerpos
	clock.settime(GameData.time)
	cam.campos(GameData.playerpos)

func _process(delta):
	bounds.boundingcheck()
	bounds.resettriggers()
	
	cords.text = str(player.global_position.floor())
	time.text = str(clock.formate_time())
	
	hptext.text = "%d/%d" % [GameData.playerdata["hp"],GameData.playerdata["maxhp"]]
	hp.value = (float(GameData.playerdata["hp"]) / GameData.playerdata["maxhp"])*100
	
	_check_marker_reach()

func _check_marker_reach():
	if is_instance_valid(marker):
		if player.global_position.distance_to(marker.global_position) <= ARRIVAL_THRESHOLD:
			marker.queue_free()
			player.stop_move()

func _input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		var click_pos = get_global_mouse_position()
		var click_radius = 19.0
		
		if is_instance_valid(marker):
			if click_pos.distance_to(marker.global_position) <= click_radius:
				marker.queue_free()
				player.stop_move()
				return
			else:
				marker.global_position = click_pos
				player.target_position = click_pos
				player.move_to(click_pos)
		else: 
			marker = Marker.instantiate()
			add_child(marker)
			marker.global_position = click_pos
			player.target_position = click_pos
			player.move_to(click_pos)
