class_name GameBoard
extends Node2D

const DIRECTIONS: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

@export var grid: Grid = preload("res://Grid.tres")

@onready var _unit_overlay: UnitOverlay = $UnitOverlay
@onready var _unit_path: UnitPath = $UnitPath

var _units: Dictionary[Vector2i, Unit] = {}
var _active_unit: Unit
var _walkable_cells: Array[Vector2i] = []

func _ready() -> void:
	_reinitialize()


func is_occupied(cell: Vector2i) -> bool:
	return _units.has(cell)

func _reinitialize() -> void:
	_units.clear()
	
	for child in self.get_children():
		var unit := child as Unit
		if not unit:
			continue
		_units[unit.cell] = unit

func get_walkable_cells(unit: Unit) -> Array[Vector2i]:
	return _flood_fill(unit.cell, unit.move_range)
	
func _flood_fill(cell: Vector2i, max_distance: int) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	var stack: Array[Vector2i] = [cell]
	
	while not stack.is_empty():
		var current = stack.pop_back()
		
		if not grid.is_within_bounds(current):
			continue
		if current in array:
			continue
			
		var difference: Vector2i = (current - cell).abs()
		var distance := difference.x + difference.y
		if distance > max_distance:
			continue
			
		array.append(current)
		
		for direction in DIRECTIONS:
			var coordinates: Vector2i = current + direction
			
			if is_occupied(coordinates):
				continue
			if coordinates in array:
				continue
			
			stack.append(coordinates)
	return array
		
		
func _select_unit(cell: Vector2i) -> void:
	if not _units.has(cell):
		return
		
	_active_unit = _units[cell]
	_active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(_active_unit)
	_unit_overlay.draw(_walkable_cells)
	_unit_path.initialize(_walkable_cells)
	
	
func _deselect_active_unit() -> void:
	_active_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()
	
func _clear_active_unit() -> void:
	_active_unit = null
	_walkable_cells.clear()
	
func _move_active_unit(new_cell: Vector2i) -> void:
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
		
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	
	_deselect_active_unit()
	_active_unit.walk_along(_unit_path.current_path)
	await _active_unit.walk_finished
	_clear_active_unit()
	


func _on_cursor_moved(new_cell: Vector2i) -> void:
	if _active_unit and _active_unit.is_selected:
		_unit_path.draw(_active_unit.cell, new_cell)


func _on_cursor_accept_pressed(cell: Vector2i) -> void:
	if not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected:
		_move_active_unit(cell)
		
		
func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()
