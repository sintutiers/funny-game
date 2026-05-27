extends RapierCharacterBody2D

@export var speed_keys: int = 200
@export var speed_touch: int = 180
var target: Vector2

func _ready() -> void:
	target = global_position

func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if input_dir != Vector2.ZERO:
		velocity = input_dir * speed_keys
		target = global_position
	else:
		if global_position.distance_to(target) > 10:
			var direction: Vector2 = global_position.direction_to(target)
			velocity = direction * speed_touch
		else:
			velocity = Vector2.ZERO
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed(&"interact"):
		target = get_global_mouse_position()
