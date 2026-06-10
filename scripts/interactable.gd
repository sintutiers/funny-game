class_name interaction_manager
extends RapierArea2D

signal interacted_static(body: RapierArea2D)
#signal touched(body: Node2D)
#signal stepped_on(body: Node2D)

func _on_door_interacted_static(body: RapierArea2D) -> void:
	interacted_static.emit(body)

#TODO need to add sleep animation for this to go to second screen
