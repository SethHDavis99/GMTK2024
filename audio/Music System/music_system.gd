extends Node

@onready var layers = [null,$Small,$Mid,$Base]
var total_time = 0

func _process(delta: float) -> void:
	total_time += delta

func toggle_music(index, music_on):
	if layers[index]:
		layers[index].seek(fmod(total_time, $Base.stream.get_length()))
		var tween = get_tree().create_tween()
		tween.tween_property(layers[index],"volume_db",-80.0 * float(!music_on),1).set_trans(Tween.TRANS_LINEAR)

func stop_all():
	for i in layers.size():
		if i:
			toggle_music(i,false)
