extends Node2D


@export_file("*.tscn") var next_scene: String
@onready var door: interaction_manager = %Door


func _ready() -> void:
	var _err: Error = door.interacted_static.connect(_on_door_interacted_static) as Error


func _on_door_interacted_static(_body: RapierArea2D) -> void:
	SceneLoader.load_scene(next_scene)
