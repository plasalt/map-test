extends Control

@onready var button: Button = $Button
var tween: Tween

func _ready() -> void:
	# Connect hover signals to functions
	button.mouse_entered.connect(_on_button_mouse_entered)
	button.mouse_exited.connect(_on_button_mouse_exited)

func _on_button_mouse_entered() -> void:
	_animate_button(0.0)

func _on_button_mouse_exited() -> void:
	_animate_button(-15.0)

func _animate_button(target_x: float) -> void:
	# Stop any currently running tween to avoid jitter/fighting
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween()
	
	# Set transition style and easing curve
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	# Animate position over 0.3 seconds
	tween.tween_property(button, "position:x", target_x, 0.3)
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control.tscn")
	pass # Replace with function body.
