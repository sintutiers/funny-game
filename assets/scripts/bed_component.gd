# bed_component.gd
class_name BedComponent
extends Node
@onready var interactable: Interactable = get_parent()
func _ready() -> void:
	interactable.interacted.connect(_on_interacted)
func _on_interacted(_by: RapierArea2D) -> void:
	action()
func action() -> void:
	pass
