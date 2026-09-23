class_name UnitOverlay
extends TileMapLayer

func draw(cells: Array[Vector2i]) -> void:
	clear()
	for cell in cells:
		set_cell(cell, 0, Vector2i.ZERO)
