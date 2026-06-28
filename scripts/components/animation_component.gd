# animation_component.gd
class_name AnimationComponent
extends Node

@export var buffer_duration: float = 0.3
@export var idle_delay: float = 3.0

var walk_buffer: float = 0.0
var idle_time: float = 0.0
var current_facing: MovementComponent.Direction = MovementComponent.Direction.DOWN

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	sprite.play("start")
	#pass

func play_walk(facing: MovementComponent.Direction) -> void:
	walk_buffer = buffer_duration
	idle_time = 0.0
	current_facing = facing
	var anim_name: String = MovementComponent.DIRECTION_NAMES.get(facing, "down")
	if sprite.animation != anim_name or not sprite.is_playing():
		sprite.play(anim_name)

func update_walk_buffer(delta: float) -> void:
	walk_buffer -= delta
	if walk_buffer > 0.0:
		var anim_name: String = MovementComponent.DIRECTION_NAMES.get(current_facing, "down")
		if sprite.animation != anim_name or not sprite.is_playing():
			sprite.play(anim_name)
	else:
		walk_buffer = 0.0
		idle_time += delta
		if idle_time >= idle_delay:
			play_idle()

func play_idle() -> void:
	if sprite.animation != "idle" or not sprite.is_playing():
		sprite.play("idle")
