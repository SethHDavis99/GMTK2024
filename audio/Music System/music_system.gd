extends Node

@onready var layers = [null,$Small,$Mid,$Base]

func toggle_music(index, music_on):
	if layers[index]:
		var tween = get_tree().create_tween()
		tween.tween_property(layers[index],"volume_db",-80.0 * float(!music_on),1).set_trans(Tween.TRANS_LINEAR)

func stop_all():
	for i in layers.size():
		if i:
			toggle_music(i,false)
