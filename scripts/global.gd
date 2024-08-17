extends Node

var hovered_player = null
var players = {}

func play_sound(sound : AudioStream, position : Vector2, pitch := 1.0):
	var inst = preload("res://objects/sound_inst.tscn").instantiate()
	inst.stream = sound
	inst.global_position = position
	inst.pitch_scale = pitch
	add_child(inst)
	return inst
