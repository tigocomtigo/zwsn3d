extends Node3D

@onready var line_edit = $CanvasLayer/VBoxContainer/HBoxContainer/LineEdit
@onready var objeto_3d = $MeshInstance3D
var file_dialog: FileDialog

var ui_active = false
var min_size = 0.1
var max_size = 100

func click_handler():
	if !ui_active:
		ui_active = true
		$CanvasLayer.show()
	else:
		ui_active = false
		$CanvasLayer.hide()
	pass

func _ready():
	setup_file_dialog()
	line_edit.text_submitted.connect(_on_text_submitted)
	line_edit.clear_button_enabled = true

func _on_text_submitted(new_text: String):
	_resize_object(new_text)
	line_edit.release_focus()

func _resize_object(size_text: String):
	if size_text.is_valid_float():
		var new_size = size_text.to_float()
		
		new_size = clamp(new_size, min_size, max_size)
		
		objeto_3d.scale = Vector3(new_size, new_size, new_size)
		
		line_edit.text = str(new_size)
		
	else:
		line_edit.text = ""

func setup_file_dialog():
	file_dialog = FileDialog.new()
	file_dialog.title = "Selecione uma imagem"
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.png; PNG Images", "*.jpg; JPEG Images", "*.jpeg; JPEG Images", "*.webp; WebP Images"]
	file_dialog.file_selected.connect(_on_file_selected)
	add_child(file_dialog)

func _on_file_selected(path):
	# Carrega a imagem de forma assíncrona para não travar o jogo
	var image = Image.load_from_file(path)
	
	if image != null:
		apply_texture(image, path)
	else:
		print("Falha ao carregar imagem:", path)

func apply_texture(image: Image, path: String):
	# Cria a textura
	var texture = ImageTexture.create_from_image(image)
	
	# Cria ou atualiza o material
	var material: StandardMaterial3D
	if objeto_3d.material_override == null:
		material = StandardMaterial3D.new()
	else:
		material = objeto_3d.material_override
	
	# Configura o material
	material.albedo_texture = texture
	objeto_3d.material_override = material
	
	# Ajusta o aspect ratio do plano
	var aspect_ratio = float(image.get_width()) / image.get_height()
	objeto_3d.scale.x = aspect_ratio
	


func _on_button_pressed() -> void:
	file_dialog.popup_centered(Vector2i(800, 600))
	pass # Replace with function body.
