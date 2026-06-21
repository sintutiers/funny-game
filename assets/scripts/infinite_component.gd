class_name InfiniteComponent
extends Node

@export var wall_vertical_a: Node2D
@export var wall_vertical_b: Node2D
@export var wall_horizontal_a: Node2D
@export var wall_horizontal_b: Node2D
@export var teleport_margin: float = 32.0

var level_bounds: Rect2 = Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0))

@onready var body: CharacterBody2D = get_parent()


func _ready() -> void:
	var computed: Rect2 = _compute_level_bounds()
	if computed.size.x > 0.0 and computed.size.y > 0.0:
		level_bounds = computed
	else:
		push_warning("InfiniteComponent: bro forgot to drag the walls in (or they got no collision shape), falling back to the default box 💀")


func check_wall_teleport() -> void:
	# vibe check every collision this frame, see if we clipped a wall
	for i: int in body.get_slide_collision_count():
		var collision: KinematicCollision2D = body.get_slide_collision(i)
		if collision == null:
			continue

		var collider: Object = collision.get_collider()
		if not (collider is Node2D and (collider as Node2D).is_in_group("walls")):
			continue

		var normal: Vector2 = collision.get_normal()

		var left_edge: float = level_bounds.position.x
		var right_edge: float = level_bounds.position.x + level_bounds.size.x
		var top_edge: float = level_bounds.position.y
		var bottom_edge: float = level_bounds.position.y + level_bounds.size.y

		# bonk left wall, yeet to the right side
		if normal.x > 0.5:
			body.global_position.x = right_edge - teleport_margin
		# bonk right wall, yeet to the left side
		elif normal.x < -0.5:
			body.global_position.x = left_edge + teleport_margin
		# bonk top wall, yeet to the bottom
		elif normal.y > 0.5:
			body.global_position.y = bottom_edge - teleport_margin
		# bonk bottom wall, yeet to the top
		elif normal.y < -0.5:
			body.global_position.y = top_edge + teleport_margin

		break


func _compute_level_bounds() -> Rect2:
	if wall_vertical_a == null or wall_vertical_b == null or wall_horizontal_a == null or wall_horizontal_b == null:
		push_warning("InfiniteComponent: one or more wall slots empty in the Inspector, go drag them in fr fr")
		return Rect2()

	var a_rects: Array[Rect2] = []
	var b_rects: Array[Rect2] = []
	var c_rects: Array[Rect2] = []
	var d_rects: Array[Rect2] = []
	_collect_collision_rects(wall_vertical_a, a_rects)
	_collect_collision_rects(wall_vertical_b, b_rects)
	_collect_collision_rects(wall_horizontal_a, c_rects)
	_collect_collision_rects(wall_horizontal_b, d_rects)

	if a_rects.is_empty() or b_rects.is_empty() or c_rects.is_empty() or d_rects.is_empty():
		push_warning("InfiniteComponent: found the wall nodes but no collision shape on one of em, that's a no from me dawg")
		return Rect2()

	var rect_a: Rect2 = _merge_rects(a_rects)
	var rect_b: Rect2 = _merge_rects(b_rects)
	var rect_c: Rect2 = _merge_rects(c_rects)
	var rect_d: Rect2 = _merge_rects(d_rects)

	# whichever vertical wall is further left wins "left", easy
	var left_rect: Rect2 = rect_a if rect_a.position.x < rect_b.position.x else rect_b
	var right_rect: Rect2 = rect_b if left_rect == rect_a else rect_a

	# same deal but up/down for the horizontal walls
	var top_rect: Rect2 = rect_c if rect_c.position.y < rect_d.position.y else rect_d
	var bottom_rect: Rect2 = rect_d if top_rect == rect_c else rect_c

	var left_inner: float = left_rect.position.x + left_rect.size.x
	var right_inner: float = right_rect.position.x
	var top_inner: float = top_rect.position.y + top_rect.size.y
	var bottom_inner: float = bottom_rect.position.y

	return Rect2(Vector2(left_inner, top_inner), Vector2(right_inner - left_inner, bottom_inner - top_inner))


func _collect_collision_rects(node: Node2D, out: Array[Rect2]) -> void:
	# check the node itself first, covers dragging in the CollisionShape2D directly
	_collect_shape_rect(node, out)
	# then check its kids too just in case it's a StaticBody2D parent type beat
	for child: Node in node.get_children():
		if child is Node2D:
			_collect_shape_rect(child as Node2D, out)
			if child.get_child_count() > 0:
				_collect_collision_rects(child as Node2D, out)


func _collect_shape_rect(node: Node2D, out: Array[Rect2]) -> void:
	if node is CollisionShape2D:
		var cs: CollisionShape2D = node as CollisionShape2D
		var shape: Shape2D = cs.shape
		if shape == null:
			return
		if shape is RectangleShape2D:
			var size: Vector2 = (shape as RectangleShape2D).size
			var local_rect: Rect2 = Rect2(-size * 0.5, size)
			out.append(_transform_rect(cs.global_transform, local_rect))
		elif shape is CircleShape2D:
			var r: float = (shape as CircleShape2D).radius
			var local_rect: Rect2 = Rect2(Vector2(-r, -r), Vector2(r, r) * 2.0)
			out.append(_transform_rect(cs.global_transform, local_rect))
	elif node is CollisionPolygon2D:
		var poly: CollisionPolygon2D = node as CollisionPolygon2D
		var pts: PackedVector2Array = poly.polygon
		if pts.is_empty():
			return
		var local_rect: Rect2 = Rect2(pts[0], Vector2.ZERO)
		for p: Vector2 in pts:
			local_rect = local_rect.expand(p)
		out.append(_transform_rect(poly.global_transform, local_rect))


func _merge_rects(rects: Array[Rect2]) -> Rect2:
	var result: Rect2 = rects[0]
	for r: Rect2 in rects:
		result = result.merge(r)
	return result


func _transform_rect(xform: Transform2D, local_rect: Rect2) -> Rect2:
	var corners: Array[Vector2] = [
		local_rect.position,
		local_rect.position + Vector2(local_rect.size.x, 0.0),
		local_rect.position + Vector2(0.0, local_rect.size.y),
		local_rect.position + local_rect.size,
	]
	var result: Rect2 = Rect2(xform * corners[0], Vector2.ZERO)
	for c: Vector2 in corners:
		result = result.expand(xform * c)
	return result
