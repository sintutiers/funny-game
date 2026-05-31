class_name MetaPlayer
extends Node2D

@export var speed_keys: int = 200
@export var speed_touch: int = 180
@export var door: Node2D 
@export var player_body: CharacterBody2D

var target: Vector2

func _ready() -> void:
	target = player_body.global_position

func _physics_process(_delta: float) -> void:
	var input_raw: Vector2 = Input.get_vector("left", "right", "up", "down")
	var input_dir: Vector2 = input_raw.sign()
	#var input_dir: Vector2 = Vector2(sign(input_raw.x), sign(input_raw.y))

	if input_dir != Vector2.ZERO:
		player_body.velocity = input_dir * speed_keys
		target = player_body.global_position
	elif player_body.global_position.distance_to(target) > 10:
		var direction: Vector2 = player_body.global_position.direction_to(target)
		player_body.velocity = direction.sign() * speed_touch
	else:
		player_body.velocity = Vector2.ZERO

	player_body.move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact()
		print("buttonpress")
		
# remove mouse/touch movement in final build
	if event is InputEventMouseButton and event.is_action_pressed(&"interact"):
		var mouse_event: InputEventMouseButton = event
		target = mouse_event.global_position

func interact() -> void:
	if door:
		door._on_door_interacted(player_body)
