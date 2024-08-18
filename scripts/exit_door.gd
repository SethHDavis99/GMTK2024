extends Area2D

@export var required_size := 1.0
@export var next_level : PackedScene

const MAX_SIZE = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer.visible = true
	scale = Vector2(required_size / MAX_SIZE, required_size / MAX_SIZE)
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/ColorRect,"modulate",Color(1,1,1,0),1)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and body.size == required_size:
		$FinishLevel/GPUParticles2D.emitting = true
		if next_level:
			Global.play_sound(preload("res://audio/GMTK2024_DollGoalReach_02.ogg"),global_position)
			var tween = get_tree().create_tween()
			tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
			tween.tween_property($CanvasLayer/ColorRect,"modulate",Color.WHITE,4)
			tween.finished.connect(on_tween_finished)
			get_tree().paused = true
			$FinishLevel/GPUParticles2D.emitting = true
		else:
			printerr("ERROR: No next level provided!")

func on_tween_finished():
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_packed",next_level)
