class_name MetaPlayer
extends Node2D

enum DIRECTION {NONE, UP, DOWN, LEFT, RIGHT}

@export var speed_keys: int = 200
@export var speed_touch: int = 180
@export var door: Node2D
@export var player_body: CharacterBody2D

@onready var sprite: AnimatedSprite2D = $RapierCharacterBody2D/AnimatedSprite2D

var target: Vector2
var facing: DIRECTION = DIRECTION.DOWN

func _ready() -> void:
	target = player_body.global_position
	sprite.play("down")

func _physics_process(_delta: float) -> void:
	var input_raw: Vector2 = Input.get_vector("left", "right", "up", "down")
	var input_dir: Vector2 = input_raw

	if input_dir != Vector2.ZERO:
		player_body.velocity = input_dir * speed_keys
		target = player_body.global_position
		
		_update_facing(input_dir)
		_play_direction_animation()
		
	elif player_body.global_position.distance_to(target) > 10:
		var direction: Vector2 = player_body.global_position.direction_to(target)
		player_body.velocity = direction * speed_touch
		
		_update_facing(direction)
		_play_direction_animation()
	else:
		player_body.velocity = Vector2.ZERO

	player_body.move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact()
		print("buttonpress")
	if event is InputEventMouseButton and event.is_action_pressed(&"interact"): # TODO remove or rework the touch events for final build
		var mouse_event: InputEventMouseButton = event
		target = mouse_event.global_position

func interact() -> void:
	if door:
		door._on_door_interacted($RapierCharacterBody2D/Interact_player)

func _update_facing(direction: Vector2) -> void:
	if direction.x > 0:
		facing = DIRECTION.RIGHT
	elif direction.x < 0:
		facing = DIRECTION.LEFT
	elif direction.y > 0:
		facing = DIRECTION.DOWN
	elif direction.y < 0:
		facing = DIRECTION.UP

func _play_direction_animation() -> void:
	var anim_name: String = str(DIRECTION.keys()[facing]).to_lower()
	if sprite.animation != anim_name:
		sprite.play(anim_name)
