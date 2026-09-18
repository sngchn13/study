class_name Grid
extends Resource

@export var size: Vector2i = Vector2i(20,20)
@export var cell_size: Vector2 = Vector2(80.0,80.0)

func get_half_cell_size() -> Vector2:
	return cell_size / 2

func calculate_map_position(grid_position: Vector2i) -> Vector2:
	return Vector2(grid_position) * cell_size + get_half_cell_size()


func calculate_grid_coordinates(map_position: Vector2) -> Vector2i:
	return (map_position / cell_size).floor()


func is_within_bounds(cell_coordinates: Vector2i) -> bool:
	var out = cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y


func clamp(grid_position: Vector2i) -> Vector2i:
	var out = grid_position
	out.x = clamp(out.x, 0, size.x -1)
	out.y = clamp(out.y, 0, size.y -1)
	return out
	
func as_index(cell: Vector2i) -> int:
	return cell.y * size.x + cell.x
