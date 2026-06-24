# interaction_component.gd
class_name InteractionComponent
extends Node

@onready var interact_area: RapierArea2D = %InteractAreaPlayer
@onready var movement: MovementComponent = %MovementComponent

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		interact()

func interact() -> void:
	var overlapping_areas: Array[Area2D] = interact_area.get_overlapping_areas()
	var overlapping_bodies: Array[Node2D] = interact_area.get_overlapping_bodies()
	var overlapping: Array[Node2D] = []
	overlapping.append_array(overlapping_areas)
	overlapping.append_array(overlapping_bodies)
	var closest: Interactable = null
	var closest_dist_sq: float = INF
	for node: Node2D in overlapping:
		var interactable: Interactable = null
		for child: Node in node.get_children():
			if child is Interactable:
				interactable = child as Interactable
				break
		if not interactable:
			for sibling: Node in node.get_parent().get_children():
				if sibling is Interactable:
					interactable = sibling as Interactable
					break
		if interactable:
			var d2: float = movement.body.global_position.distance_squared_to(node.global_position)
			if d2 < closest_dist_sq:
				closest_dist_sq = d2
				closest = interactable
	if closest:
		movement.set_interacting(true)
		closest.trigger(interact_area)

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	movement.set_interacting(false)
