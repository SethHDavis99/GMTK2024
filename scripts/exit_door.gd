extends Area2D

@export var required_size := 1
@export var next_level : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect/Label.text = str(required_size)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and body.size == required_size:
		Global.play_sound(preload("res://audio/GMTK2024_DollGoalReach_02.ogg"),global_position)
		$Timer.start()
		get_tree().paused = true

func _on_timer_timeout() -> void:
	get_tree().call_deferred("change_scene_to_packed",next_level)
	get_tree().paused = false
