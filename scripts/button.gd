extends Area2D

@export_node_path("Door") var linked_door

var activated = false

func _ready() -> void:
	if !linked_door:
		printerr("ERROR: Button is not linked to a door!")
		set_process(false)

func _process(delta: float) -> void:
	if not activated and has_overlapping_bodies():
		activated = true
		get_node(linked_door).toggle_open(activated)
		$AnimatedSprite2D.play("press")
	if activated and !has_overlapping_bodies():
		activated = false
		get_node(linked_door).toggle_open(activated)
		$AnimatedSprite2D.play_backwards("press")
