# DialogueComponent.gd
class_name DialogueComponent
extends Node
@onready var interactable: Interactable = get_parent()
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
func _ready() -> void:
	interactable.interacted.connect(_on_interacted)
func _on_interacted(_by: RapierArea2D) -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
