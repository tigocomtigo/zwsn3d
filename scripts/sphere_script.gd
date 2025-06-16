extends MeshInstance3D

var camera: Camera3D
var collider_name
var clicked = 0
var ray_count := 128
var ray_length := 10.0

@onready var SignalRay := load("res://scripts/signal_ray.gd") as GDScript

func ready():
	pass

func generate_rays():
	for i in range(ray_count):
		var theta = randf() * PI * 4.0
		var phi = acos(randf() * 2.0 - 1.0)

		var dir = Vector3(
			sin(phi) * cos(theta),
			sin(phi) * sin(theta),
			cos(phi)
		).normalized()
		
		var ray = SignalRay.new()
		
		ray.initial_direction = dir * ray_length

		add_child(ray)
		ray.start()

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
