extends Camera3D

@export var move_speed := 5.0
@export var sprint_multiplier := 2.5
@export var mouse_sensitivity := 0.003

var velocity := Vector3.ZERO
var sprinting := false

var yaw := 0.0
var pitch := 0.0
var is_middle_button_pressed := false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		is_middle_button_pressed = event.pressed

		if is_middle_button_pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion and is_middle_button_pressed:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))
		rotation = Vector3(pitch, yaw, 0)
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		var viewport = get_viewport()
		
		# Converte a posição do mouse para coordenadas da viewport
		var mouse_pos = viewport.get_mouse_position()
		
		# Cria um raio da câmera para a posição do mouse no mundo 3D
		var from = self.project_ray_origin(mouse_pos)
		var to = from + self.project_ray_normal(mouse_pos) * 1000
		
		# Configura a query do raycast
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		if result:
			if result.collider.is_in_group('collision_childs'):
				result.collider.get_parent().collision_handler()
			if result.collider.is_in_group('floor'):
				result.collider.get_parent().get_parent().click_handler()

func _physics_process(delta):
	if not is_middle_button_pressed:
		return  # Só move enquanto o botão do meio estiver pressionado

	var direction := Vector3.ZERO

	var forward := -global_transform.basis.z
	var right := global_transform.basis.x
	var up := global_transform.basis.y

	if Input.is_action_pressed("move_forward"):
		direction += forward
	if Input.is_action_pressed("move_back"):
		direction -= forward
	if Input.is_action_pressed("move_left"):
		direction -= right
	if Input.is_action_pressed("move_right"):
		direction += right
	if Input.is_action_pressed("move_up"):
		direction += up
	if Input.is_action_pressed("move_down"):
		direction -= up

	direction = direction.normalized()
	sprinting = Input.is_action_pressed("sprint")

	var current_speed := move_speed
	if sprinting:
		current_speed *= sprint_multiplier

	velocity = direction * current_speed
	global_position += velocity * delta
