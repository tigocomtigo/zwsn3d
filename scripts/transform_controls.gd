extends Node3D

enum TRANSFORM_MODE { TRANSLATE, ROTATE, SCALE }
var current_mode = TRANSFORM_MODE.TRANSLATE
var selected_object = null

# Referências para os eixos
@onready var x_axis = $XAxis
@onready var y_axis = $YAxis
@onready var z_axis = $ZAxis

func _ready():
	#hide_axes()
	pass

func show_axes(object):
	selected_object = object
	global_transform.origin = object.global_transform.origin
	show()
	
	# Ativa os eixos conforme o modo atual
	match current_mode:
		TRANSFORM_MODE.TRANSLATE:
			setup_translate_axes()
		TRANSFORM_MODE.ROTATE:
			setup_rotate_axes()
		TRANSFORM_MODE.SCALE:
			setup_scale_axes()

func hide_axes():
	selected_object = null
	hide()

func setup_translate_axes():
	# Configura aparência para movimento
	x_axis.setup(Color.RED, Vector3.RIGHT)
	y_axis.setup(Color.GREEN, Vector3.UP)
	z_axis.setup(Color.BLUE, Vector3.FORWARD)

func setup_rotate_axes():
	# Configura aparência para rotação
	x_axis.setup(Color.RED, Vector3.RIGHT, true)
	y_axis.setup(Color.GREEN, Vector3.UP, true)
	z_axis.setup(Color.BLUE, Vector3.FORWARD, true)

func setup_scale_axes():
	# Configura aparência para escala
	x_axis.setup(Color.RED, Vector3.RIGHT, false, true)
	y_axis.setup(Color.GREEN, Vector3.UP, false, true)
	z_axis.setup(Color.BLUE, Vector3.FORWARD, false, true)

func _process(delta):
	if selected_object:
		global_transform.origin = selected_object.global_transform.origin
