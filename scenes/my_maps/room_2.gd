extends Node2D

@export_file("*.tscn") var next_scene: String


func _on_bed_interacted_static(body: Area2D) -> void:
	SceneLoader.load_scene(next_scene)
