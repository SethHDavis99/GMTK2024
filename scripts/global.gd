extends Node

var hovered_player = null
var selected_player = null
var players = {}

func play_sound(sound : AudioStream, position : Vector2, pitch_range := [1.0,1.0]):
	var inst = preload("res://objects/sound_inst.tscn").instantiate()
	inst.stream = sound
	inst.global_position = position
	inst.pitch_scale = randf_range(pitch_range[0],pitch_range[1])
	add_child(inst)
	return inst
