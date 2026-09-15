extends Control

@onready var button: Button = $Button
@onready var option: Button = $options

# Track individual tweens for each button
var tweens: Dictionary = {}

func _ready() -> void:
	# Connect signals for both buttons
	_setup_button_signals(button)
	_setup_button_signals(option)

func _setup_button_signals(btn: Button) -> void:
	btn.mouse_entered.connect(_animate_button.bind(btn, 0.0))
	btn.mouse_exited.connect(_animate_button.bind(btn, -15.0))

func _animate_button(btn: Button, target_x: float) -> void:
	if tweens.has(btn) and tweens[btn].is_running():
		tweens[btn].kill()

	var tween = create_tween()
	tweens[btn] = tween

	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "position:x", target_x, 0.3)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/infodump.tscn")
