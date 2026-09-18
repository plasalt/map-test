extends Label

#animates a floating damage label that moves and fades out
func animate_damage_popup(damage_amount: int) -> void:
	
	#sets the text to display the damage value
	text = str(damage_amount)
	
	#resets the alpha (visblity)
	modulate.a = 1.0 
	
	#resets the scale 
	scale = Vector2(1, 1)
	
	#creates a new tween (used to animate objects)
	var tween = create_tween()
	
	#enbles parrallel mode so multiple values can be animated at once
	tween.set_parallel(true)
	
	#sets a target position for the label to float to 
	var target_position = position + Vector2(-50.0, -30.0)
	
	#animate the position change over a 0.5 second time frame using a smooth quadratic ease out effect
	tween.tween_property(self, "position", target_position, 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	#changes the alpha to 0 over a 0.5 second time frame to make the label fade out 
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	#chain the animations together so they run simultaneously and deletes the node
	tween.chain().tween_callback(queue_free)
