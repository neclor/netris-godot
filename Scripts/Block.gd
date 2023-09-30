extends Node2D

var Block_scene = load("res://Scenes/Block.tscn")
var block_texture = preload("res://Assets/Sprites/Block.png")

const block_size = 32

const interior_old_color = Color("#ff0000")
const external_old_color = Color("#00ff00")

func change_color(block_sprite, interior_new_color, external_new_color):
	block_sprite.modulate = interior_new_color if block_sprite.modulate == interior_old_color else block_sprite.modulate
	block_sprite.modulate = external_new_color if block_sprite.modulate == external_old_color else block_sprite.modulate
	

	#for x in block_size:
		#for y in block_size:

			#if new_block_image.get_pixel(x, y) == interior_old_color:
				#new_block_image.set_pixel(x, y, interior_new_color)

			#if new_block_image.get_pixel(x, y) == external_old_color:
				#new_block_image.set_pixel(x, y, external_new_color)

	var new_texture = ImageTexture.new()
	#new_texture.create_from_image(new_block_image)
	block_sprite.texture = block_texture
