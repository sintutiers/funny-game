extends Node2D


@export_file("*.tscn") var next_scene: String

@onready var door: interaction_manager = %Door
@onready var bed: interaction_manager = %Bed


func _ready() -> void:
	if not door.interacted_static.is_connected(_on_door_interacted_static):
		var _err_door: Error = door.interacted_static.connect(_on_door_interacted_static) as Error
	if not bed.interacted_static.is_connected(_on_bed_interacted_static):
		var _err_bed: Error = bed.interacted_static.connect(_on_bed_interacted_static) as Error


func _on_door_interacted_static(_body: RapierArea2D) -> void:
	SceneLoader.load_scene(next_scene)


func _on_bed_interacted_static(_body: RapierArea2D) -> void:
	#DEBUG:
	print("bed_interacted")
