extends Node2D

const block_size = 32

const field_height = 22
const field_width = 10

const top_border = -(field_height / 2) * Block.block_size
const bottom_border = (field_height / 2 - 1) * Block.block_size
const left_border = -(field_width / 2) * Block.block_size
const right_border =(field_width / 2) * Block.block_size

const initial_coordinates = Vector2(-Block.block_size, -(field_height / 2 - 1) * Block.block_size)

const figure_names = ["i", "o", "t", "j", "l", "s", "z"]

var structure_bag = []
var next_name

var locked_blocks = []

var figure
#var figure_ghost
#var figure_next

func _ready():
	init()

func init():
	chose_next_structure()
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
		structure_bag = figure_names.duplicate()

	var new_structure_index = randi_range(0, len(structure_bag) - 1)
	var current_name = next_name

	next_name = structure_bag[new_structure_index]
	structure_bag.remove_at(new_structure_index)

	return current_name
