# door_component.gd
class_name DoorComponent
extends Node

@onready var interactable: Interactable = get_parent()
@onready var transition_component: TransitionComponent = _find_transition()
@export_file("*.tscn") var next_scene: String

func _find_transition() -> TransitionComponent:
	for child in get_parent().get_children():
		if child is TransitionComponent:
			return child
	return null

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted(_by: RapierArea2D) -> void:
	if transition_component:
		await transition_component.play()
	SceneLoader.load_scene(next_scene)
