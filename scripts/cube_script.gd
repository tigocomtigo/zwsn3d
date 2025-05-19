extends MeshInstance3D

var controls: Node3D
var camera: Camera3D
var collider_name
var clicked = 0

func collision_handler():
	if !clicked:
		controls.show_axes(self)
		clicked = 1
	else:
		controls.hide_axes()
		clicked = 0
