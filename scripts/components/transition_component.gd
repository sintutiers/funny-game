# transition_component.gd
@tool
class_name TransitionComponent
extends Node

const TRANSITION_SCENE: String = "res://assets/scenes/ui/transition_handler.tscn"

var transition_name: StringName = &"pixelate_in"

func _get_property_list() -> Array[Dictionary]:
	if not ResourceLoader.exists(TRANSITION_SCENE):
		return []
	var packed: PackedScene = load(TRANSITION_SCENE) as PackedScene
	if not packed:
		return []
	var instance: Node = packed.instantiate()
	var handler: AnimationPlayer = instance.get_node_or_null("Handler") as AnimationPlayer
	var anims: PackedStringArray = handler.get_animation_list() if handler else PackedStringArray()
	instance.free()
	return [{
		"name": "transition_name",
		"type": TYPE_STRING_NAME,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(anims)
	}]

func _get(property: StringName) -> Variant:
	if property == &"transition_name": return transition_name
	return null

func _set(property: StringName, value: Variant) -> bool:
	if property != &"transition_name": return false
	transition_name = StringName(str(value))
	return true

func play() -> void:
	var anim: AnimationPlayer = TransitionHandler.get_node("%Handler") as AnimationPlayer
	if not anim:
		push_error("TransitionComponent: Handler AnimationPlayer not found")
		return
	if transition_name and anim.has_animation(transition_name):
		anim.play(transition_name)
		await anim.animation_finished
