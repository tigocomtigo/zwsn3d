extends Node3D

@onready var mesh_instance = $MeshInstance3D
@onready var area = $Area3D

var axis_direction: Vector3
var is_active := false

func setup(color: Color, direction: Vector3):
	axis_direction = direction
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.emission = color
	material.emission_energy = 0.5
	mesh_instance.material_override = material
	
	# Configura colisão
	var collision = area.get_node("CollisionShape3D")
	collision.shape = BoxShape3D.new()
	collision.shape.size = Vector3(0.2, 0.2, 0.2)
	
	# Orientação
	look_at(global_position + direction, Vector3.UP if direction != Vector3.UP else Vector3.BACK)

func set_mode_translate():
	mesh_instance.mesh = CylinderMesh.new()
	mesh_instance.scale = Vector3(0.05, 1.0, 0.05)

func set_mode_rotate():
	mesh_instance.mesh = TorusMesh.new()
	mesh_instance.scale = Vector3(0.2, 0.2, 0.2)

func set_mode_scale():
	mesh_instance.mesh = BoxMesh.new()
	mesh_instance.scale = Vector3(0.1, 0.1, 0.1)

func _on_area_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			get_parent().active_axis = self
			is_active = true
			# Destaque visual
			mesh_instance.material_override.emission_energy = 1.5
		else:
			get_parent().active_axis = null
			is_active = false
			mesh_instance.material_override.emission_energy = 0.5
