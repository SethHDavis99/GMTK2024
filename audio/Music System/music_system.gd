extends Node

@onready var layers = [null,$Small,$Mid,$Base]

func toggle_music(index, music_on):
	layers[index].volume_db = -80 * int(!music_on)
