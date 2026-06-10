#room1
extends RoomBase


@onready var bed: interaction_manager = %Bed


func _ready() -> void:
	super()
	bed.interacted_static.connect(_on_bed_interacted_static)


func _exit_tree() -> void:
	super()
	bed.interacted_static.disconnect(_on_bed_interacted_static)


func _on_bed_interacted_static(_body: RapierArea2D) -> void:
	#DEBUG:
	print("bed_interacted")
