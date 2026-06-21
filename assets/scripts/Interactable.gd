# Interactable.gd
class_name Interactable
extends RapierArea2D
signal interacted(by: RapierArea2D)
func trigger(by: RapierArea2D) -> void:
	interacted.emit(by)
