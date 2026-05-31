extends RapierArea2D
class_name interaction_manager

signal interacted(body: Node2D)

signal touched(body: Node2D)

signal stepped_on(body: Node2D)


func _on_door_interacted(body: Node2D) -> void:
	interacted.emit(body)
