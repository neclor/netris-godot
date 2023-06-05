extends Node


@onready var Block_scene = preload("res://Block.tscn")

@onready var I_Figure = ["I", Vector2(-cell_size, 0), Vector2(0, 0), Vector2(cell_size, 0), Vector2(cell_size * 2, 0)]
@onready var O_Figure = ["O", Vector2(0, 0), Vector2(cell_size, 0), Vector2(cell_size, cell_size), Vector2(0, cell_size)]
@onready var T_Figure = ["T", Vector2(-cell_size, 0), Vector2(0, 0), Vector2(cell_size, 0), Vector2(cell_size, cell_size)]
@onready var J_Figure = ["J", Vector2(-cell_size, 0), Vector2(0, 0), Vector2(0, cell_size), Vector2(cell_size, 0)]
@onready var L_Figure = ["L", Vector2(-cell_size, cell_size), Vector2(-cell_size, 0), Vector2(0, 0), Vector2(cell_size, 0)]
@onready var S_Figure = ["S", Vector2(-cell_size, cell_size), Vector2(0, cell_size), Vector2(0, 0), Vector2(cell_size, 0)]
@onready var Z_Figure = ["Z", Vector2(-cell_size, 0), Vector2(0, 0), Vector2(0, cell_size), Vector2(cell_size, cell_size)]
@onready var figures = [I_Figure, O_Figure, T_Figure, J_Figure, L_Figure, S_Figure, Z_Figure]

var cell_size = 128

var figure_bag = figures.duplicate()
var next_figure

func creation_figure():
	var figure_blocks = []

	var figure = chose_next_figure()

	var block = Block.Block_scene.instantiate()
	var block_sprite = block.get_node("Block")
	Block.change_block_color(block_sprite, figure[0]) 

	Main.blocks_relative_coords = figure.slice(1).duplicate()

	for i in len(figure) - 1:
		figure_blocks.append(block)

	return figure_blocks




func chose_next_figure():
	if figure_bag == []:
		figure_bag = figures

	var new_figure_index = randi_range(0, len(figure_bag) - 1)
	var present_figure = next_figure

	next_figure = figure_bag[new_figure_index]
	figure_bag.remove_at(new_figure_index)

	return present_figure



func move_down():
	print (Main.a)
	pass

func check_move_down():
	pass

func move_rotation():
	pass

func check_move_rotation():
	pass




