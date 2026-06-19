class_name MetaRoom
extends Node2D

@export_file("*.tscn") var next_scene: String

@onready var door: InteractionManager = %Door


func _ready() -> void:
	if door.interacted_static.is_connected(_on_door_interacted_static):
		push_warning("RoomBase: door.interacted_static already connected, duplicate connection?")
	else:
		door.interacted_static.connect(_on_door_interacted_static)

func _exit_tree() -> void:
	if door.interacted_static.is_connected(_on_door_interacted_static):
		door.interacted_static.disconnect(_on_door_interacted_static)

func _on_door_interacted_static(_body: RapierArea2D) -> void:
	SceneLoader.load_scene(next_scene)
