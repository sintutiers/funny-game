extends Node2D

@export_file("*.tscn") var next_scene: String

func _ready():
	%Door.interacted_static.connect(_on_door_interacted_static)

func _on_door_interacted_static(body: RapierArea2D) -> void:
	SceneLoader.load_scene(next_scene)
