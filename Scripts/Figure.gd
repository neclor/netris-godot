class_name Figure extends Node

var top_border
var bottom_border
var left_border
var right_border

var coordinates
var blocks_coordinates
@export var blocks: Array = []

var figures_bag

func _init(set_top_border, set_bottom_border, set_left_border, set_right_border, initial_coordinates, structure):
	top_border = set_top_border
	bottom_border = set_bottom_border
	left_border = set_left_border
	right_border = set_right_border

	coordinates = initial_coordinates
	blocks_coordinates = structure.slice(2).duplicate()

	for i in len(structure) - 2:
		var block = Block.Block_scene.instantiate()
		var block_sprite = block.get_node("Block")
		Block.change_color(block_sprite, structure[1], structure[1])
		blocks.append(block)
	update_blocks_coordinates()


func update_blocks_coordinates():
	for i in len(blocks):
		blocks[i].position = blocks_coordinates[i] + coordinates

func check_move_down(locked_blocks):
	if blocks == []:
		return null

	else:
		var locked_blocks_coordinates = []

		for block in locked_blocks:
			locked_blocks_coordinates.append(block.position)

		var next_coordinates_block

		for block in blocks:
			next_coordinates_block = block.position
			next_coordinates_block.y += Block.block_size

			if next_coordinates_block.y > bottom_border or next_coordinates_block in locked_blocks_coordinates:
				return false

		move_down()
		return true

func move_down():
	coordinates.y += Block.block_size
	update_blocks_coordinates()
