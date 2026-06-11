#room1
extends RoomBase


@onready var bed: interaction_manager = %Bed


func _ready() -> void:
	super()
	if bed.interacted_static.is_connected(_on_bed_interacted_static):
		push_warning("room1: bed.interacted_static is already connected, duplicate connection?")
	bed.interacted_static.connect(_on_bed_interacted_static)


func _exit_tree() -> void:
	super()
	bed.interacted_static.disconnect(_on_bed_interacted_static)


func _on_bed_interacted_static(_body: RapierArea2D) -> void:
	#DEBUG:
	print("bed_interacted")
