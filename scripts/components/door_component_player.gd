#door_component.gd
class_name DoorComponent
extends Node

@onready var interactable: Interactable = get_parent()
@onready var transition_component: TransitionComponent = get_parent().get_node_or_null("transition") as TransitionComponent
@export_file("*.tscn") var next_scene: String

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted(_by: RapierArea2D) -> void:
	if transition_component:
		await transition_component.play()
	SceneLoader.load_scene(next_scene)
