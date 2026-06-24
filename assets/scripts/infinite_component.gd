# infinite_component.gd
class_name InfiniteRoom
extends Node

@export var player: CharacterBody2D
@export var wall_left: CollisionShape2D
@export var wall_right: CollisionShape2D
@export var wall_top: CollisionShape2D
@export var wall_bottom: CollisionShape2D
@export var teleport_margin: float = 32.0

var _bounds: Rect2 = Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0))

func _ready() -> void:
	process_priority = 10
	call_deferred("_init_bounds")

func _init_bounds() -> void:
	var computed: Rect2 = _compute_level_bounds()
	if computed.size.x > 0.0 and computed.size.y > 0.0:
		_bounds = computed

func _physics_process(_delta: float) -> void:
	if not player:
		return
	for i: int in player.get_slide_collision_count():
		var collision: KinematicCollision2D = player.get_slide_collision(i)
		if not collision:
			continue
		if not (collision.get_collider() as Node2D).is_in_group("walls"):
			continue
		var normal: Vector2 = collision.get_normal()
		var left: float = _bounds.position.x
		var right: float = _bounds.position.x + _bounds.size.x
		var top: float = _bounds.position.y
		var bottom: float = _bounds.position.y + _bounds.size.y
		if normal.x > 0.5:
			player.global_position.x = right - teleport_margin
		elif normal.x < -0.5:
			player.global_position.x = left + teleport_margin
		elif normal.y > 0.5:
			player.global_position.y = bottom - teleport_margin
		elif normal.y < -0.5:
			player.global_position.y = top + teleport_margin
		break

func _compute_level_bounds() -> Rect2:
	if not wall_left or not wall_right or not wall_top or not wall_bottom:
		return Rect2()
	var left_rects: Array[Rect2] = []
	var right_rects: Array[Rect2] = []
	var top_rects: Array[Rect2] = []
	var bottom_rects: Array[Rect2] = []
	_collect_collision_rects(wall_left, left_rects)
	_collect_collision_rects(wall_right, right_rects)
	_collect_collision_rects(wall_top, top_rects)
	_collect_collision_rects(wall_bottom, bottom_rects)
	if left_rects.is_empty() or right_rects.is_empty() or top_rects.is_empty() or bottom_rects.is_empty():
		return Rect2()
	var left_merged: Rect2 = _merge_rects(left_rects)
	var right_merged: Rect2 = _merge_rects(right_rects)
	var top_merged: Rect2 = _merge_rects(top_rects)
	var bottom_merged: Rect2 = _merge_rects(bottom_rects)
	var left_inner: float = left_merged.position.x + left_merged.size.x
	var right_inner: float = right_merged.position.x
	var top_inner: float = top_merged.position.y + top_merged.size.y
	var bottom_inner: float = bottom_merged.position.y
	return Rect2(Vector2(left_inner, top_inner), Vector2(right_inner - left_inner, bottom_inner - top_inner))

func _collect_collision_rects(node: Node2D, out: Array[Rect2]) -> void:
	_collect_shape_rect(node, out)
	for child: Node in node.get_children():
		if child is Node2D:
			_collect_shape_rect(child as Node2D, out)
			if child.get_child_count() > 0:
				_collect_collision_rects(child as Node2D, out)

func _collect_shape_rect(node: Node2D, out: Array[Rect2]) -> void:
	if node is CollisionShape2D:
		var cs: CollisionShape2D = node as CollisionShape2D
		var shape: Shape2D = cs.shape
		if not shape:
			return
		if shape is RectangleShape2D:
			var size: Vector2 = (shape as RectangleShape2D).size
			out.append(_transform_rect(cs.global_transform, Rect2(-size * 0.5, size)))
		elif shape is CircleShape2D:
			var r: float = (shape as CircleShape2D).radius
			out.append(_transform_rect(cs.global_transform, Rect2(Vector2(-r, -r), Vector2(r, r) * 2.0)))
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
