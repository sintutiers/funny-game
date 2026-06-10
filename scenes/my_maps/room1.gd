extends Node2D


@export_file("*.tscn") var next_scene: String

@onready var door: interaction_manager = %Door
@onready var bed: interaction_manager = %Bed


func _ready() -> void:
	door.interacted_static.connect(_on_door_interacted_static)
	bed.interacted_static.connect(_on_bed_interacted_static)


func _exit_tree() -> void:
	door.interacted_static.disconnect(_on_door_interacted_static)
	bed.interacted_static.disconnect(_on_bed_interacted_static)


func _on_door_interacted_static(_body: RapierArea2D) -> void:
	SceneLoader.load_scene(next_scene)


func _on_bed_interacted_static(_body: RapierArea2D) -> void:
	#DEBUG:
	print("bed_interacted")
