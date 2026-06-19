class_name InteractionManager
extends RapierArea2D

signal interacted_static(body: RapierArea2D)
#signal touched(body: Node2D)
#signal stepped_on(body: Node2D)

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_door_interacted_static(body: RapierArea2D) -> void:
	interacted_static.emit(body)

#TODO need to add sleep animation for this to go to second screen
