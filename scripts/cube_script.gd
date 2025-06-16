extends MeshInstance3D

var camera: Camera3D
var collider_name
var clicked = 0

func collision_handler():
	if !Global.has_active_object:
		if Global.control_type == 'move':
			Global.axis_move.show_axes(self)
			Global.has_active_object = true
		elif Global.control_type == 'scale':
			Global.axis_scale.show_axes(self)
			Global.has_active_object = true
	else:
		Global.axis_move.hide_axes()
		Global.axis_scale.hide_axes()
		Global.has_active_object = false
