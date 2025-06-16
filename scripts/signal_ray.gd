extends Node3D

@export var initial_direction: Vector3 = Vector3.FORWARD

var energy: float = 10.0
var max_bounces := 3
var ray_length := 100.0
var attenuation_per_meter := 0.05

func _ready():
	if not has_node("debug_draw"):
		var debug = Node3D.new()
		debug.name = "debug_draw"
		add_child(debug)

func clear_debug_rays():
	var debug = get_node("debug_draw")
	for child in debug.get_children():
		child.queue_free()

func _physics_process(delta: float) -> void:
	clear_debug_rays()
	start()

func start():
	var origin = global_transform.origin
	var world_dir = global_transform.basis * initial_direction.normalized()
	propagate(origin, world_dir, energy, 0)

func propagate(origin: Vector3, dir: Vector3, energy_left: float, bounce: int):
	if energy_left <= 0 or bounce > max_bounces:
		return

	var to_point = origin + (dir * ray_length)
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	query.from = origin
	query.to = to_point
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var exclude_list := []
	var current = self
	while current:
		if current is CollisionObject3D:
			exclude_list.append(current.get_rid())
		current = current.get_parent()
	query.exclude = exclude_list

	var result = space.intersect_ray(query)

	if result:
		var hit_pos = result.position
		show_debug_raycast(origin, hit_pos)

		var normal = result.normal
		var collider = result.collider
		var distance = origin.distance_to(hit_pos)
		var energy_after = energy_left - (distance * attenuation_per_meter)

		if energy_after <= 0:
			return

		if collider.is_in_group("sensors"):
			collider.get_parent().receive_signal(energy_after)
		else:
			var reflect_dir = dir.bounce(normal).normalized()
			propagate(hit_pos + reflect_dir * 0.001, reflect_dir, energy_after * 0.8, bounce + 1)
	else:
		show_debug_raycast(origin, to_point)

func show_debug_raycast(origin: Vector3, to_point: Vector3):
	var debug_node = get_node("debug_draw")
	
	var line = ImmediateMesh.new()
	line.surface_begin(Mesh.PRIMITIVE_LINES)
	
	var local_from = debug_node.to_local(origin)
	var local_to = debug_node.to_local(to_point)
	
	line.surface_add_vertex(local_from)
	line.surface_add_vertex(local_to)
	line.surface_end()
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = line
	debug_node.add_child(mesh_instance)
