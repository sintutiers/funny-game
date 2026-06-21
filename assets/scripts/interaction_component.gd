#InteractionComponent.gd
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
	var closest: Interactable = null
	var closest_dist_sq: float = INF
	for area: Area2D in overlapping_areas:
		if area is Interactable:
			var d2: float = movement.body.global_position.distance_squared_to(area.global_position)
			if d2 < closest_dist_sq:
				closest_dist_sq = d2
				closest = area
	if closest:
		movement.set_interacting(true)
		closest.trigger(interact_area)
func _on_dialogue_ended(_resource: DialogueResource) -> void:
	movement.set_interacting(false)
