extends Node

@onready var layers = [null,$Small,$Mid,$Base]

func toggle_music(index, music_on):
	var tween = get_tree().create_tween()
	tween.tween_property(layers[index],"volume_db",-80.0 * float(!music_on),1).set_trans(Tween.TRANS_LINEAR)
