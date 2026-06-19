#room1
extends MetaRoom

@onready var bed: InteractionManager = %Bed

func _ready() -> void:
	super()
	if bed.interacted_static.is_connected(_on_bed_interacted_static):
		push_warning("room1: bed.interacted_static already connected, duplicate connection?")
	else:
		bed.interacted_static.connect(_on_bed_interacted_static)

func _exit_tree() -> void:
	super()
	if bed.interacted_static.is_connected(_on_bed_interacted_static):
		bed.interacted_static.disconnect(_on_bed_interacted_static)

func _on_bed_interacted_static(_body: RapierArea2D) -> void:
	bed.action()
	#print("bed_interacted")#DEBUG
