extends CanvasLayer

func _process(float) -> void:
	if Global.has_active_object:
		$TransformType.show()
	else:
		$TransformType.hide()

func _on_move_pressed() -> void:
	if Global.control_type != 'move':
		Global.control_type = 'move'
		Global.axis_move.show_axes(Global.axis_scale.movable_objects)
		Global.axis_scale.hide_axes()
	pass # Replace with function body.

func _on_scale_pressed() -> void:
	if Global.control_type != 'scale':
		Global.control_type = 'scale'
		Global.axis_scale.show_axes(Global.axis_move.movable_objects)
		Global.axis_move.hide_axes()
	pass # Replace with function body.


func _on_pitch_text_submitted(new_text: String) -> void:
	var angle_deg = new_text.to_float()
	Global.active_object.rotation_degrees.x = angle_deg
	pass # Replace with function body.

func _on_yaw_text_submitted(new_text: String) -> void:
	var angle_deg = new_text.to_float()
	Global.active_object.rotation_degrees.y = angle_deg
	pass # Replace with function body.

func _on_roll_text_submitted(new_text: String) -> void:
	var angle_deg = new_text.to_float()
	Global.active_object.rotation_degrees.z = angle_deg
	pass # Replace with function body.


func _on_delete_pressed() -> void:
	get_tree().call_group("axes", "hide_axes")
	Global.active_object.queue_free()
	pass # Replace with function body.
