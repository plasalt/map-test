extends Control

@onready var button: Button = $Button
@onready var exit: Button = $exit

# Track individual tweens for each button
var tweens: Dictionary = {}

func _ready() -> void:
	# Connect signals for both buttons
	_setup_button_signals(button)
	_setup_button_signals(exit)
	


func _setup_button_signals(btn: Button) -> void:
	#when the mouse button hovers over the button animate it forward
	btn.mouse_entered.connect(_animate_button.bind(btn, 0.0))
	#when the mouse exits the button animte it back
	btn.mouse_exited.connect(_animate_button.bind(btn, -15.0))


func _animate_button(btn: Button, target_x: float) -> void:
	# 	if a tween is already running on this button kill it first so they don't fight
	if tweens.has(btn) and tweens[btn].is_running():
		tweens[btn].kill()
	
	#create a tween and store it in a dictionarary
	var tween = create_tween()
	tweens[btn] = tween
	
	#apply a bouncy back transition effect with an ease-out curve
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	#smoothly animate the button's X position to the target value over 0.3 seconds
	tween.tween_property(btn, "position:x", target_x, 0.3)

#change the scene when the button is pressed and resets the player data
func _on_button_pressed() -> void:
	GameData.playerpos = Vector2(500,200)
	GameData.playerdata = {
		"maxhp": 110,
		"hp": 100,
		"damage": 5, 
		"name": "jeb",
		"damagemod": 0 
	}
	
	get_tree().change_scene_to_file("res://scenes/infodump.tscn")

#when button press exit game
func _on_exit_button_down() -> void:
	get_tree().quit()
