extends Area2D

var activated = false

func _process(delta: float) -> void:
	if not activated and has_overlapping_bodies():
		$ColorRect.color = Color.GREEN
		activated = true
	if activated and !has_overlapping_bodies():
		$ColorRect.color = Color.RED
		activated = false
