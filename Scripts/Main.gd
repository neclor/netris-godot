extends Node2D

@onready var Block_scene = preload("res://Block.tscn")

var figure_blocks = []
var blocks_relative_coords

func _ready():
	pass







func _on_game_timer_timeout():
	if figure_blocks == []:
		figure_blocks = Figure.creation_figure()
		

		for i in len(figure_blocks):
			print(figure_blocks[i])
			$Field.add_child(figure_blocks[i])
		update_cords()
	

func update_cords():
	print(figure_blocks)
	for i in len(figure_blocks):
		figure_blocks[i].position = blocks_relative_coords[i]

func update_blocks_relative_coords(blocks_relative_coords_new):
	blocks_relative_coords = blocks_relative_coords_new


func _on_start_button_pressed():
	pass
	#var block = Block_scene.instantiate()
	#var Block_sprite = block.get_node("Block")
	#Block.change_block_color(Block_sprite)
	#$Field.add_child(Block_scene.instantiate())
	#block.position = Vector2(200, 200)
	#Block.change_block_color(Block_sprite)
	#$Field.add_child(block)
	#Figure.move_down()
