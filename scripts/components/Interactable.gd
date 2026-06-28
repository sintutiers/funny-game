# Interactable.gd
class_name Interactable
extends Node

@export var animate_on_interact: bool = false

signal interacted(by: RapierArea2D)

func _ready() -> void:
	if animate_on_interact:
		for sibling: Node in get_parent().get_children():
			if sibling is AnimatedSprite2D:
				(sibling as AnimatedSprite2D).pause()
				break

func trigger(by: RapierArea2D) -> void:
	if animate_on_interact:
		for sibling: Node in get_parent().get_children():
			if sibling is AnimatedSprite2D:
				(sibling as AnimatedSprite2D).play()
				break
	interacted.emit(by)
