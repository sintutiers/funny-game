# movement_component.gd
class_name MovementComponent
extends Node


enum Direction {NONE, UP, DOWN, LEFT, RIGHT}

const DIRECTION_NAMES: Dictionary[Direction, String] = {
	Direction.UP: "up",
	Direction.DOWN: "down",
	Direction.LEFT: "left",
	Direction.RIGHT: "right",
}
const IDLE_DELAY: float = 3.0

@export var move_speed: int = 200

var facing: Direction = Direction.DOWN
var idle_time: float = 0.0
var is_interacting: bool = false

@onready var animation: AnimationComponent = %AnimationComponent
@onready var body: CharacterBody2D = get_parent()


func _physics_process(delta: float) -> void:
	if is_interacting:
		body.velocity = Vector2.ZERO
		body.move_and_slide()
		return

	var input_dir: Vector2 = Input.get_vector(&"left", &"right", &"up", &"down")
	if input_dir != Vector2.ZERO:
		idle_time = 0.0
		body.velocity = input_dir * move_speed
		_update_facing(input_dir)
		animation.play_direction(facing)
	else:
		body.velocity = Vector2.ZERO
		idle_time += delta
		if idle_time >= IDLE_DELAY:
			animation.play_idle()

	body.move_and_slide()
	body.position = body.position.round()#temp, should be improved


func set_interacting(value: bool) -> void:
	is_interacting = value
	if value:
		body.velocity = Vector2.ZERO


func _update_facing(direction: Vector2) -> void:
	var threshold: float = 0.5
	var new_facing: Direction = facing
	if abs(direction.x) >= abs(direction.y):
		if direction.x > threshold:
			new_facing = Direction.RIGHT
		elif direction.x < -threshold:
			new_facing = Direction.LEFT
	else:
		if direction.y > threshold:
			new_facing = Direction.DOWN
		elif direction.y < -threshold:
			new_facing = Direction.UP
	facing = new_facing
