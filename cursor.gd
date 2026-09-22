@tool
class_name Cursor
extends Node2D

signal accept_pressed(cell)
signal moved(new_cell)

@export var grid: Grid = preload("res://Grid.tres")
@export var ui_cooldown := 0.1

var cell: Vector2i:
	set(value):
		var new_cell: Vector2i = grid.clamp(value)
		if new_cell == cell:
			return
		
		cell = new_cell
		self.position = grid.calculate_map_position(cell)
		moved.emit(cell)
		_timer.start()
		
@onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.wait_time = self.ui_cooldown
	self.position = grid.calculate_map_position(cell)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.cell = grid.calculate_grid_coordinates(event.position)
	
	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		accept_pressed.emit(self.cell)
		self.get_viewport().set_input_as_handled()

	var should_move := event.is_pressed()
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()
		
	if not should_move:
		return
	
	if event.is_action("ui_right"):
		self.cell += Vector2i.RIGHT
	elif event.is_action("ui_up"):
		self.cell += Vector2i.UP
	elif event.is_action("ui_left"):
		self.cell += Vector2i.LEFT
	elif event.is_action("ui_down"):
		self.cell += Vector2i.DOWN
	
func _draw() -> void:
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.ALICE_BLUE, false, 2.0)
	
	
	
