class_name PathFinder
extends RefCounted

##pathfinder는 유닛선할때마다 새로 만들어질건데 그 이유는 패스파인더 하나를 싱글톤으로 만들어쓰면 모든 맵 상태를 계속 최신화 해야함. 따라서 유닛 선택시 만들기로함.

const DIRECTIONS: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

var _grid: Grid
var _astar := AStar2D.new()

func _init(grid: Grid, walkable_cells: Array[Vector2i]) -> void:
	_grid = grid
	
	var cell_mappings: Dictionary[Vector2i, int] = {}
	for cell in walkable_cells:
		cell_mappings[cell] = _grid.as_index(cell)
	
	_add_and_connect_points(cell_mappings)
	
func calculate_point_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	var start_index := _grid.as_index(start)
	var end_index := _grid.as_index(end)
	var path: Array[Vector2i] = []
	
	if not (_astar.has_point(start_index) and _astar.has_point(end_index)):
		return path
		
	for point in _astar.get_point_path(start_index, end_index):
		path.append(Vector2i(point))
	
	return path

	
func _add_and_connect_points(cell_mappings: Dictionary[Vector2i, int]) -> void:
	for cell in cell_mappings:
		_astar.add_point(cell_mappings[cell], Vector2(cell))
		
	for cell in cell_mappings:
		for neighbor_index in _find_neighbor_indices(cell, cell_mappings):
			_astar.connect_points(cell_mappings[cell], neighbor_index)
		
		
		
func _find_neighbor_indices(cell: Vector2i, cell_mappings: Dictionary[Vector2i, int]) -> Array[int]:
	var out: Array[int] = []
	
	for direction in DIRECTIONS:
		var neighbor := cell + direction
		
		if not cell_mappings.has(neighbor):
			continue
		
		if not _astar.are_points_connected(cell_mappings[cell], cell_mappings[neighbor]):
			out.append(cell_mappings[neighbor])
			
	return out
