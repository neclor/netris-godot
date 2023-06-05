extends Node2D

var figure_blocks = []
var blocks_relative_coords

func _ready():
	pass

func _on_game_timer_timeout():
	if figure_blocks == []:
		figure_blocks = Figure.figure_creation()







func _on_start_button_pressed():

	#var block = Block_scene.instantiate()
	#var Block_sprite = block.get_node("Block")
	#Block.change_block_color(Block_sprite)
	#$Field.add_child(Block_scene.instantiate())
	#block.position = Vector2(200, 200)
	#Block.change_block_color(Block_sprite)
	#$Field.add_child(block)
	#Figure.move_down()





	






























