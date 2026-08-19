extends Label

func animate_damage_popup(damage_amount: int) -> void:
	text = str(damage_amount)
	modulate.a = 1.0 
	scale = Vector2(1, 1)
	var tween = create_tween()
	tween.set_parallel(true)
	var target_position = position + Vector2(-50.0, -30.0)
	tween.tween_property(self, "position", target_position, 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.chain().tween_callback(queue_free)
