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
const figures = [I_Figure, O_Figure, T_Figure, J_Figure, L_Figure, S_Figure, Z_Figure]

var figures_bag
var next_figure

var locked_blocks

var figure
#var figure_ghost
#var figure_next

func _ready():
	init()

func init():
	locked_blocks = []

	figures_bag = figures.duplicate()
	var new_figure_index = randi_range(0, len(figures_bag) - 1)
	next_figure = figures_bag[new_figure_index]
	figures_bag.remove_at(new_figure_index)

	figure = Figure.new(top_border, bottom_border, left_border, right_border, initial_coordinates)
	for block in figure.instantiate_figure(chose_next_figure()):
			$Field.add_child(block)

func _on_game_timer_timeout():
	if !figure.check_move_down(locked_blocks):
		locked_blocks.append_array(figure.blocks)

		figure = Figure.new(top_border, bottom_border, left_border, right_border, initial_coordinates)

		for block in figure.instantiate_figure(chose_next_figure()):
			$Field.add_child(block)

func chose_next_figure():
	if figures_bag == []:
		figures_bag = figures.duplicate()

	var new_figure_index = randi_range(0, len(figures_bag) - 1)
	var present_figure = next_figure

	next_figure = figures_bag[new_figure_index]
	figures_bag.remove_at(new_figure_index)

	return present_figure
