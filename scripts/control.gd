extends Control

@onready var player = $CharacterBody2D
@onready var marker = $marker
@onready var bounds = $bounds
@export var clock: Node
@onready var time = $Camera2D/time
@onready var cords = $Camera2D/cords
const Marker = preload("res://scenes/marker.tscn")

func _ready():
	player.global_position = GameData.playerpos
	clock.settime(GameData.time)
	
	pass


func _process(delta):
	bounds.boundingcheck()
	bounds.resettriggers()
	
	cords.text = str(player.global_position.floor())
	time.text = str(clock.formate_time())
	pass

func _input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		var click_pos = get_global_mouse_position()
		var click_radius = 19.0
		
		if is_instance_valid(marker):
			print(marker.global_position)
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
			
			
