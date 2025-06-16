extends Node3D

@onready var camera = $'../Camera3D'
@onready var x_axis = $x
@onready var y_axis = $y
@onready var z_axis = $z
var movable_objects: Node3D = null

var active_axis: Vector3 = Vector3.ZERO
var is_axis_selected := false
var last_mouse_pos: Vector2

func _ready() -> void:
	$x/Cylinder/StaticBody3D/CollisionShape3D.disabled = true
	$y/Cylinder/StaticBody3D/CollisionShape3D.disabled = true
	$z/Cylinder/StaticBody3D/CollisionShape3D.disabled = true

func _process(delta: float) -> void:
	if movable_objects:
		self.global_position = movable_objects.global_position
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_handle_click(event.position)
			else:
				# Solta o eixo quando o botão for liberado
				is_axis_selected = false
				active_axis = Vector3.ZERO
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif is_axis_selected and event is InputEventMouseMotion:
		_transform_objects_along_axis(event)



func _handle_click(mouse_pos: Vector2):
	var space_state = get_world_3d().direct_space_state
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000.0
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1  # só colide com objetos na layer 1
	query.exclude = []        # nada para excluir
	
	var result = space_state.intersect_ray(query)
	
	if result:
		var clicked = result.collider
		var clicked_root = clicked.get_parent().get_parent()
		match clicked_root:
			x_axis:
				active_axis = Vector3.RIGHT
				is_axis_selected = true
			y_axis:
				active_axis = Vector3.UP
				is_axis_selected = true
			z_axis:
				active_axis = Vector3.FORWARD
				is_axis_selected = true
		last_mouse_pos = mouse_pos
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _transform_objects_along_axis(event: InputEventMouseMotion):
	var delta := event.relative
	var sensitivity := 0.01
	var scale_change := Vector3.ZERO

	if active_axis == Vector3.RIGHT:
		scale_change.x = delta.x * sensitivity
	elif active_axis == Vector3.UP:
		scale_change.y = -delta.y * sensitivity
	elif active_axis == Vector3.FORWARD:
		scale_change.z = delta.x * sensitivity

	var new_scale := movable_objects.scale + scale_change

	new_scale = new_scale.clamp(Vector3(0.1, 0.1, 0.1), Vector3(100, 100, 100))

	movable_objects.scale = new_scale
	get_tree().call_group("axes",'change_scale', new_scale)


func hide_axes():
	$x/Cylinder/StaticBody3D/CollisionShape3D.disabled = true
	$y/Cylinder/StaticBody3D/CollisionShape3D.disabled = true
	$z/Cylinder/StaticBody3D/CollisionShape3D.disabled = true
	self.visible = false
	movable_objects = null
	pass

func show_axes(object: MeshInstance3D):
	global_position = object.global_position
	self.visible = true
	movable_objects = object
	$x/Cylinder/StaticBody3D/CollisionShape3D.disabled = false
	$y/Cylinder/StaticBody3D/CollisionShape3D.disabled = false
	$z/Cylinder/StaticBody3D/CollisionShape3D.disabled = false
	pass

func change_scale(new_scale):
	self.scale = new_scale
