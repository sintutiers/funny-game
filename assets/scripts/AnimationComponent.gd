class_name AnimationComponent
extends Node

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	sprite.play("down")

func play_direction(facing: MovementComponent.Direction) -> void:
	var anim_name: String = MovementComponent.DIRECTION_NAMES.get(facing, "down")
	if sprite.animation != anim_name:
		sprite.play(anim_name)

func play_idle() -> void:
	if sprite.animation != "idle":
		sprite.play("idle")
