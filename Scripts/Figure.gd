extends Node
class_name Figure

var top_border
var bottom_border
var left_border
var right_border

const figures_description = {
	"i": [Color("#00ffff"), Vector2(-Block.block_size, 0), Vector2(0, 0), Vector2(Block.block_size, 0), Vector2(Block.block_size * 2, 0)],
	"o": [Color("#ffff00"), Vector2(0, -Block.block_size), Vector2(Block.block_size, -Block.block_size), Vector2(0, 0), Vector2(Block.block_size, 0)],
	"t": [Color("#ff00ff"), Vector2(0, -Block.block_size), Vector2(-Block.block_size, 0), Vector2(0, 0), Vector2(Block.block_size, 0)],
	"j": [Color("#ff7f00"), Vector2(-Block.block_size, -Block.block_size), Vector2(-Block.block_size, 0), Vector2(0, 0), Vector2(Block.block_size, 0)],
	"l": [Color("#0000ff"), Vector2(Block.block_size, -Block.block_size), Vector2(-Block.block_size, 0), Vector2(0, 0), Vector2(Block.block_size, 0)],
	"s": [Color("#00ff00"), Vector2(0, -Block.block_size), Vector2(Block.block_size, -Block.block_size), Vector2(-Block.block_size, 0), Vector2(0, 0)],
	"z": [ Color("#ff0000"), Vector2(-Block.block_size, -Block.block_size), Vector2(0, -Block.block_size), Vector2(0, 0), Vector2(Block.block_size, 0)],
}

var coordinates
var blocks_coordinates
var blocks

func _init(figure_name, initial_coordinates, set_top_border, set_bottom_border, set_left_border, set_right_border):
	top_border = set_top_border
	bottom_border = set_bottom_border
	left_border = set_left_border
	right_border = set_right_border

	coordinates = initial_coordinates

	var figure_description = figures_description[figure_name];

	blocks_coordinates = figure_description.slice(1)

	var color = figure_description[0]

	blocks = []

	for i in len(figure_description) - 1:
		var block = Block.Block_scene.instantiate()
		var block_sprite = block.get_node("Block")

		Block.change_color(block_sprite, color, color)

		blocks.append(block)

	update_blocks_coordinates()

func update_blocks_coordinates():
	for i in len(blocks):
		blocks[i].position = blocks_coordinates[i] + coordinates

func check_move_down(locked_blocks):
	if blocks == []: #or paused
		return null

	else:
		var locked_blocks_coordinates = []

		for block in locked_blocks:
			locked_blocks_coordinates.append(block.position)

		var next_block_coordinates

		for block in blocks:
			next_block_coordinates = block.position
			next_block_coordinates.y += Block.block_size

			if next_block_coordinates.y > bottom_border or next_block_coordinates in locked_blocks_coordinates:
				return false

		move_down()
		return true

func move_down():
	coordinates.y += Block.block_size
	update_blocks_coordinates()

func check_move_rotation(locked_blocks):
	if blocks == []: #or paused
		return null

	else:
		var locked_blocks_coordinates = []

		for block in locked_blocks:
			locked_blocks_coordinates.append(block.position)

		var next_block_coordinates

		for block_coordinates in blocks_coordinates:
			next_block_coordinates = Vector2(-block_coordinates.y, block_coordinates.x) + coordinates

			if next_block_coordinates.y > bottom_border or next_block_coordinates.x > right_border or next_block_coordinates.x < left_border or next_block_coordinates in locked_blocks_coordinates:
				return false

		rotation()
		return true

func rotation():
	var next_block_coordinates

	for i in len(blocks_coordinates):
		next_block_coordinates = blocks_coordinates[i].x
		blocks_coordinates[i].x = -blocks_coordinates[i].y
		blocks_coordinates[i].y = next_block_coordinates

	update_blocks_coordinates()

func check_move_right(locked_blocks):
	if blocks == []: #or paused
		return null

	else:
		var locked_blocks_coordinates = []

		for block in locked_blocks:
			locked_blocks_coordinates.append(block.position)

		var next_block_coordinates

		for block in blocks:
			next_block_coordinates = block.position
			next_block_coordinates.x += Block.block_size

			if next_block_coordinates.x > right_border or next_block_coordinates in locked_blocks_coordinates:
				return false

		move_right()
		return true

func move_right():
	coordinates.x += Block.block_size
	update_blocks_coordinates()

func check_move_left(locked_blocks):
	if blocks == []: #or paused
		return null

	else:
		var locked_blocks_coordinates = []

		for block in locked_blocks:
			locked_blocks_coordinates.append(block.position)

		var next_block_coordinates

		for block in blocks:
			next_block_coordinates = block.position
			next_block_coordinates.x -= Block.block_size

			if next_block_coordinates.x < left_border or next_block_coordinates in locked_blocks_coordinates:
				return false

		move_left()
		return true

func move_left():
	coordinates.x -= Block.block_size
	update_blocks_coordinates()





