class_name RoomBase
extends Node2D
@export_file("*.tscn") var next_scene1: String
@onready var door: interaction_manager = %Door


func _ready() -> void:
	door.interacted_static.connect(_on_door_interacted_static)
	if door.interacted_static.is_connected(_on_door_interacted_static):
		push_warning("RoomBase: door.interacted_static is already connected, duplicate connection?")
	else:
		door.interacted_static.connect(_on_door_interacted_static)


func _exit_tree() -> void:
	door.interacted_static.disconnect(_on_door_interacted_static)


func _on_door_interacted_static(_body: RapierArea2D) -> void:
	if SceneLoader.get_status() != ResourceLoader.THREAD_LOAD_LOADED:
		SceneLoader.change_scene_to_loading_screen()
	else:
		SceneLoader.change_scene_to_resource()
