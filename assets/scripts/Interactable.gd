# Interactable.gd
class_name Interactable
extends Node

signal interacted(by: RapierArea2D)

func trigger(by: RapierArea2D) -> void:
	interacted.emit(by)
