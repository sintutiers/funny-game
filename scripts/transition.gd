extends AnimationPlayer

@onready var texture_rect: TextureRect = %TextureRect

func _ready() -> void:
	texture_rect.hide()

func prepare_texture() -> void:
	texture_rect.modulate.a = 1.0
	texture_rect.show()
