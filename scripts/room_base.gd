class_name RoomBase
extends Node2D


@export_file("*.tscn") var next_scene1: String

@onready var door: interaction_manager = %Door


func _ready() -> void:
	door.interacted_static.connect(_on_door_interacted_static)


func _exit_tree() -> void:
	door.interacted_static.disconnect(_on_door_interacted_static)


func _on_door_interacted_static(_body: RapierArea2D) -> void:
	SceneLoader.load_scene(next_scene1)
