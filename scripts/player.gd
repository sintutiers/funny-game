class_name MetaPlayer
extends Node2D


const IDLE_DELAY: float = 2.0

@export var move_speed: int = 200
@export var player_body: CharacterBody2D

@onready var sprite: AnimatedSprite2D = $RapierCharacterBody2D/AnimatedSprite2D
@onready var interact_area: RapierArea2D = %Interact_area_player

var idle_time: float = 0.0


func _ready() -> void:
	sprite.play("down")


func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")

	if input_dir != Vector2.ZERO:
		idle_time = 0.0
		player_body.velocity = input_dir * move_speed
		_update_movement_animation(input_dir)
	else:
		player_body.velocity = Vector2.ZERO
		idle_time += delta
		if idle_time >= IDLE_DELAY and sprite.animation != "idle":
			sprite.play("idle")

	var _slide_result: bool = player_body.move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact()


func interact() -> void:
	#DEBUG: print interacted stuff
	var overlapping_areas: Array[Area2D] = interact_area.get_overlapping_areas()
	print("Interact area: ", interact_area)
	print("Overlapping areas: ", overlapping_areas.size())

	var closest: interaction_manager = null
	var closest_dist_sq: float = INF

	for area: RapierArea2D in overlapping_areas:
		print("- ", area.name, " | ", area.get_class())
		if area is interaction_manager:
			print(" > This IS interaction_manager!")
			var d2: float = global_position.distance_squared_to(area.global_position)
			if d2 < closest_dist_sq:
				closest_dist_sq = d2
				closest = area

	if closest:
		closest.interacted_static.emit(interact_area)
	else:
		print("No interaction_manager found")


func _update_movement_animation(direction: Vector2) -> void:
	var anim_name: String

	if direction.x > 0:
		anim_name = "right"
	elif direction.x < 0:
		anim_name = "left"
	elif direction.y > 0:
		anim_name = "down"
	elif direction.y < 0:
		anim_name = "up"
	else:
		return

	if sprite.animation != anim_name:
		sprite.play(anim_name)
