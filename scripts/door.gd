extends Area2D

@export var required_size := 1
@export_file("*.tscn") var next_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect/Label.text = str(required_size)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and body.size == required_size:
		get_tree().call_deferred("change_scene_to_file",next_level)
