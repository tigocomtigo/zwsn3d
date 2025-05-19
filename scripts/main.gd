extends Node3D
@onready var cam = $Camera3D
@onready var add_items = $CanvasLayer/AddItems

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("add_item"):
		add_items.visible = true
	else:
		add_items.visible = false
	pass

func _on_add_cube_pressed() -> void:
	var cube = MeshInstance3D.new()
	cube.set_script(load("res://scripts/cube_script.gd"))
	cube.controls = $AxisMove
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
	
	parentNode.add_child(cube)	
	cube.add_child(body)
	body.add_child(collision)
	#body.connect("input_event", Callable(self, "_on_cube_input_event"))
	



func _on_add_sphere_pressed() -> void:
	var sphere = MeshInstance3D.new()
	sphere.mesh = SphereMesh.new()
	
	var distance := 5.0

	# Cria um novo transform com a rotação da câmera
	var spawn_transform: Transform3D = cam.global_transform

	# Move o transform para frente com base na direção da câmera
	spawn_transform.origin += -cam.global_transform.basis.z * distance
	
		# Cria um transform com rotação global neutra (sem rotação)

	# Aplica o transform ao cubo
	sphere.global_transform = spawn_transform

	add_child(sphere)
	pass # Replace with function body.
