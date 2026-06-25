# door_component.gd
class_name DoorComponent
extends Node

@onready var interactable: Interactable = get_parent()
@export_file("*.tscn") var next_scene: String

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted(_by: RapierArea2D) -> void:
	SceneLoader.load_scene(next_scene)
