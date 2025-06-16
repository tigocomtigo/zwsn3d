extends Node3D
@onready var cam = $Camera3D
@onready var add_items = $CanvasLayer/AddItems

func _ready() -> void:
	Global.axis_move = $AxisMove
	Global.axis_scale = $AxisScale
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("add_item"):
		add_items.visible = true
	else:
		add_items.visible = false
	pass

func _on_add_cube_pressed() -> void:
	var cube = MeshInstance3D.new()
	cube.set_script(load("res://scripts/cube_script.gd"))
	cube.camera = $Camera3D
	cube.add_to_group('shapes')
	cube.mesh = BoxMesh.new()

	var distance := 5.0
	var spawn_transform: Transform3D = cam.global_transform
	spawn_transform.origin += -cam.global_transform.basis.z * distance
	
	cube.global_transform = spawn_transform
	cube.rotation = Vector3.ZERO

	var collision = CollisionShape3D.new()
	collision.shape = BoxShape3D.new()
	
	var body = StaticBody3D.new()
	body.add_to_group('collision_childs')
	
	var parentNode = get_node("Cubos")
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0)  # Vermelho
	cube.material_override = material
	
	parentNode.add_child(cube)	
	cube.add_child(body)
	body.add_child(collision)
	#body.connect("input_event", Callable(self, "_on_cube_input_event"))
	



func _on_add_sphere_pressed() -> void:
	var cube = MeshInstance3D.new()
	cube.set_script(load("res://scripts/sphere_script.gd"))
	cube.camera = $Camera3D
	cube.add_to_group('shapes')
	cube.mesh = SphereMesh.new()

	var distance := 5.0
	var spawn_transform: Transform3D = cam.global_transform
	spawn_transform.origin += -cam.global_transform.basis.z * distance
	
	cube.global_transform = spawn_transform
	cube.rotation = Vector3.ZERO

	var collision = CollisionShape3D.new()
	collision.shape = SphereShape3D.new()
	
	var body = StaticBody3D.new()
	body.add_to_group('collision_childs')
	body.add_to_group('signal_emmiters')
	
	var parentNode = get_node("Cubos")
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0, 1, 0)  # Verde
	cube.material_override = material
	
	parentNode.add_child(cube)	
	cube.add_child(body)
	body.add_child(collision)
	
	cube.generate_rays()


func _on_add_receptor_pressed() -> void:
	var cube = MeshInstance3D.new()
	cube.set_script(load("res://scripts/receptor_script.gd"))
	cube.camera = $Camera3D
	cube.add_to_group('shapes')
	cube.mesh = SphereMesh.new()

	var distance := 5.0
	var spawn_transform: Transform3D = cam.global_transform
	spawn_transform.origin += -cam.global_transform.basis.z * distance
	
	cube.global_transform = spawn_transform
	cube.rotation = Vector3.ZERO

	var collision = CollisionShape3D.new()
	collision.shape = SphereShape3D.new()
	
	var body = StaticBody3D.new()
	body.add_to_group('collision_childs')
	body.add_to_group('sensors')
	
	var parentNode = get_node("Cubos")
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0, 0, 1)  # Azul
	cube.material_override = material
	
	parentNode.add_child(cube)	
	cube.add_child(body)
	body.add_child(collision)
	
