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
@onready var body: CharacterBody2D = get_parent()
@onready var animation: AnimationComponent = %AnimationComponent
var idle_time: float = 0.0
var facing: Direction = Direction.DOWN
var is_interacting: bool = false
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
	_check_wall_teleport()
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
#HACK utter dogshit code that berely works for teleporting if touching walls
func _check_wall_teleport() -> void:
	for i: int in body.get_slide_collision_count():
		var collision: KinematicCollision2D = body.get_slide_collision(i)
		if collision == null:
			continue
		var collider: Object = collision.get_collider()
		if collider is Node2D and (collider as Node2D).is_in_group("walls"):
			var normal: Vector2 = collision.get_normal()
			var camera: Camera2D = get_viewport().get_camera_2d()
			var viewport_rect: Rect2 = get_viewport().get_visible_rect()
			var zoom: Vector2 = camera.zoom
			var half_width: float = (viewport_rect.size.x * 0.5) / zoom.x
			var half_height: float = (viewport_rect.size.y * 0.5) / zoom.y
			var left_edge: float = camera.global_position.x - half_width
			var right_edge: float = camera.global_position.x + half_width
			var top_edge: float = camera.global_position.y - half_height
			var bottom_edge: float = camera.global_position.y + half_height
			if normal.x > 0.5:
				body.global_position.x = right_edge - 30.0
			elif normal.x < -0.5:
				body.global_position.x = left_edge + 30.0
			elif normal.y > 0.5:
				body.global_position.y = bottom_edge - 30.0
			elif normal.y < -0.5:
				body.global_position.y = top_edge + 30.0
			break
