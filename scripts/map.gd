extends Node2D

func _on_texture_button_pressed():
	Boss.which_boss = 1 # Spider boss
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_texture_button_2_pressed():
	if 1 in CompletedLevels.completed_levels:
		Boss.which_boss = 2 # Vampire boss
		get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_texture_button_2_mouse_entered():
	if !(1 in CompletedLevels.completed_levels):
		$TextureButton2/Label.visible = true


func _on_texture_button_2_mouse_exited():
	$TextureButton2/Label.visible = false
