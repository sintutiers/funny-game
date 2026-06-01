extends Node2D

@export_file("*.tscn") var next_scene : String

func _on_door_interacted(body: Node2D) -> void:
	SceneLoader.load_scene(next_scene)


func _on_bed_interacted(body: Node2D) -> void:
	print("bed_interacted")
