@tool
class_name Unit
extends Path2D

signal walk_finished

@export var grid: Grid = preload("res://Grid.tres")
@export var move_range := 6
@export var skin: Texture2D: set = set_skin
@export var skin_offset := Vector2.ZERO: set = set_skin_offset
@export var move_speed := 600.0

var cell := Vector2i.ZERO: set = set_cell
var is_selected := false: set = set_is_selected
var _is_walking := false: set = set_is_walking

@onready var _sprite: Sprite2D = $PathFollow2D/Sprite
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _path_follow: PathFollow2D = $PathFollow2D

func set_cell(value: Vector2i):
	cell = grid.clamp(value)
	
func set_is_selected(value: bool):
	is_selected = value
	if is_selected:
		_anim_player.play("selected")
	else :
		_anim_player.play("idle")

func set_skin(value: Texture2D):
	skin = value
	if not self.is_node_ready():
		await ready
	_sprite.texture = value
		

func set_skin_offset(value: Vector2):
	skin_offset = value
	if not _sprite:
		await ready
	_sprite.position = value

	
func set_is_walking(value: bool):
	_is_walking = value
	set_process(_is_walking)
	
func _ready() -> void:
	set_process(false)
	self.cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)
	
	if not Engine.is_editor_hint():
		self.curve = Curve2D.new()
		
	##test
	var points: Array[Vector2i] = [
		Vector2i(2,2),
		Vector2i(2,5),
		Vector2i(8,5),
		Vector2i(8,7),
	]
	walk_along(points)
	
func _process(delta: float) -> void:
	_path_follow.progress += move_speed * delta
	
	if _path_follow.progress_ratio >= 1.0:
		self._is_walking = false
		_path_follow.progress = 0.0
		position = grid.calculate_map_position(cell)
		curve.clear_points()
		walk_finished.emit()
	
func walk_along(path: Array[Vector2i]):
	if path.is_empty():
		return
	
	curve.add_point(Vector2i.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
	
	cell = path[-1]
	self._is_walking = true
	
	
	
