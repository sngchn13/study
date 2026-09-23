class_name UnitPath
extends TileMapLayer

@export var grid: Grid

var _pathfinder: PathFinder
var current_path: Array[Vector2i] = []

func initialize(walkable_cells: Array[Vector2i]) -> void:
	_pathfinder = PathFinder.new(grid, walkable_cells)
	
func draw(cell_start: Vector2i, cell_end: Vector2i) -> void:
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	set_cells_terrain_connect(current_path, 0, 0)

func stop() -> void:
	_pathfinder = null
	self.clear()
