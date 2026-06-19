class_name MetaPlayer
extends Node2D

enum Direction {NONE, UP, DOWN, LEFT, RIGHT}

const IDLE_DELAY: float = 3.0

@export var move_speed: int = 200
@export var player_body: CharacterBody2D

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var interact_area: RapierArea2D = %InteractAreaPlayer

var idle_time: float = 0.0
var facing: Direction = Direction.DOWN
var is_interacting: bool = false

func _ready() -> void:
	sprite.play("down")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _physics_process(delta: float) -> void:
	if is_interacting:
		player_body.velocity = Vector2.ZERO
		var _slide_result: bool = player_body.move_and_slide()
		return
	var input_dir: Vector2 = Input.get_vector(&"left",&"right", &"up",&"down")
	if input_dir != Vector2.ZERO:
		idle_time = 0.0
		player_body.velocity = input_dir * move_speed
		_update_facing(input_dir)
		_play_direction_animation()
	else:
		player_body.velocity = Vector2.ZERO
		idle_time += delta
		if idle_time >= IDLE_DELAY and sprite.animation != "idle":
			sprite.play("idle")
	var _slide_result: bool = player_body.move_and_slide()
	_check_wall_teleport()
	#global_position = player_body.global_position #HACK what the fuck did i do here??

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		interact()

func interact() -> void:
	#DEBUG: print interacted stuff
	var overlapping_areas: Array[Area2D] = interact_area.get_overlapping_areas()
	print("Interact area: ", interact_area)
	print("Overlapping areas: ", overlapping_areas.size())
	var closest: InteractionManager = null
	var closest_dist_sq: float = INF
	for area: Area2D in overlapping_areas:
		print("- ", area.name, " | ", area.get_class())
		if area is InteractionManager:
			print(" > This IS InteractionManager!")
			var d2: float = global_position.distance_squared_to(area.global_position)
			if d2 < closest_dist_sq:
				closest_dist_sq = d2
				closest = area
	if closest:
		is_interacting = true
		player_body.velocity = Vector2.ZERO
		closest.interacted_static.emit(interact_area)
	else:
		print("No InteractionManager found")

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	is_interacting = false

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

func _play_direction_animation() -> void:
	var anim_name: String = str(Direction.keys()[facing]).to_lower()
	if sprite.animation != anim_name:
		sprite.play(anim_name)

#HACK utter dogshit code that berely works for teleporting if touching walls
func _check_wall_teleport() -> void:
	for i: int in player_body.get_slide_collision_count():
		var collision: KinematicCollision2D = player_body.get_slide_collision(i)
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
				player_body.global_position.x = right_edge - 30.0
			elif normal.x < -0.5:
				player_body.global_position.x = left_edge + 30.0
			elif normal.y > 0.5:
				player_body.global_position.y = bottom_edge - 30.0
			elif normal.y < -0.5:
				player_body.global_position.y = top_edge + 30.0
			break
