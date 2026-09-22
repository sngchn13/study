class_name UnitPath
extends TileMapLayer

@export var grid: Grid
@export var tile_source_id := 0
@export var tile_atlas_coords := Vector2i.ZERO

var _pathfinder: PathFinder
var current_path: Array[Vector2i] = []

func initialize(walkable_cells: Array[Vector2i]) -> void:
	_pathfinder = PathFinder.new(grid, walkable_cells)
	
func draw(cell_start: Vector2i, cell_end: Vector2i) -> void:
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	for cell in current_path:
		set_cell(cell, tile_source_id, tile_atlas_coords)

func stop() -> void:
	_pathfinder = null
	current_path.clear()
	self.clear()

func _ready() -> void:
	# 두 좌표로 칸 사각형의 시작과 끝을 정한다.
	var rect_start := Vector2i(4, 4)
	var rect_end := Vector2i(10, 8)

	# rect_start부터 rect_end까지 사각형을 채우는 칸 목록을 만든다.
	var points: Array[Vector2i] = []
	# for문에서 "in" 뒤에 숫자를 쓰면 range()를 부른 것과 같다.
	# 즉 "for x in 3"은 "for x in range(3)"의 줄임이다.
	for x in rect_end.x - rect_start.x + 1:
		for y in rect_end.y - rect_start.y + 1:
			points.append(rect_start + Vector2i(x, y))

	# 이 칸들로 PathFinder를 만들고 경로를 그린다.
	initialize(points)
	draw(rect_start, Vector2i(8, 7))
