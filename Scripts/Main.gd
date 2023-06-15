extends Node2D

const block_size = 32

const field_height = 22
const field_width = 10

const top_border = -(field_height / 2) * Block.block_size
const bottom_border = (field_height / 2 - 1) * Block.block_size
const left_border = -(field_width / 2) * Block.block_size
const right_border =(field_width / 2) * Block.block_size

const initial_coordinates = Vector2(-Block.block_size, -(field_height / 2 - 1) * Block.block_size)

const I_Figure = ["i", Color("#00ffff"), Vector2(-block_size, 0), Vector2(0, 0), Vector2(block_size, 0), Vector2(block_size * 2, 0)]
const O_Figure = ["o", Color("#ffff"), Vector2(0, -block_size), Vector2(block_size, -block_size), Vector2(0, 0), Vector2(block_size, 0)]
const T_Figure = ["t", Color("#ff00ff"), Vector2(0, -block_size), Vector2(-block_size, 0), Vector2(0, 0), Vector2(block_size, 0)]
const J_Figure = ["j", Color("#ff7f00"), Vector2(-block_size, -block_size), Vector2(-block_size, 0), Vector2(0, 0), Vector2(block_size, 0)]
const L_Figure = ["l", Color("#0000ff"), Vector2(block_size, -block_size), Vector2(-block_size, 0), Vector2(0, 0), Vector2(block_size, 0)]
const S_Figure = ["s", Color("#00ff00"), Vector2(0, -block_size), Vector2(block_size, -block_size), Vector2(-block_size, 0), Vector2(0, 0)]
const Z_Figure = ["z", Color("#ff0000"), Vector2(-block_size, -block_size), Vector2(0, -block_size), Vector2(0, 0), Vector2(block_size, 0)]
const structures = [I_Figure, O_Figure, T_Figure, J_Figure, L_Figure, S_Figure, Z_Figure]

var structure_bag
var next_structure

var locked_blocks

var figure
#var figure_ghost
#var figure_next

func _ready():
	init()

func init():
	locked_blocks = []

	structure_bag = structures.duplicate()
	var new_figure_index = randi_range(0, len(structure_bag) - 1)
	next_structure = structure_bag[new_figure_index]
	structure_bag.remove_at(new_figure_index)

	add_new_figure_to_field()

func _on_game_timer_timeout():
	if !figure.check_move_down(locked_blocks):
		locked_blocks.append_array(figure.blocks)

		add_new_figure_to_field()


func add_new_figure_to_field():
	figure = Figure.new(top_border, bottom_border, left_border, right_border, initial_coordinates, chose_next_structure())
	for block in figure.blocks:
		$Field.add_child(block)

func chose_next_structure():
	if structure_bag == []:
		structure_bag = structures.duplicate()

	var new_structure_index = randi_range(0, len(structure_bag) - 1)
	var present_structure = next_structure

	next_structure = structure_bag[new_structure_index]
	structure_bag.remove_at(new_structure_index)

	return present_structure
