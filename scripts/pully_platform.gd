extends Sprite2D
class_name PullyPlatform

@export_node_path("PullyPlatform") var linked_pully : NodePath

const SPEED = 50
const WEIGHT_DIFF = 10

var colliding_players : Array[Player] = []
var start_pos = Vector2.ZERO
var pully_sound = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos = $AnimatableBody2D.position
	if linked_pully:
		var inst = get_node(linked_pully)
		inst.linked_pully = get_path()
	else:
		printerr("ERROR: Pully is not linked")
		set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var total_weight = get_total_weight() - get_node(linked_pully).get_total_weight()
	
	var pos_limit = (total_weight * WEIGHT_DIFF) + start_pos.y
	var move_dir = pos_limit - $AnimatableBody2D.position.y
	var new_pos = $AnimatableBody2D.position + Vector2(0,SPEED * delta * sign(move_dir))
	if (move_dir > 0 and new_pos.y < pos_limit) or (move_dir < 0 and new_pos.y > pos_limit):
		$AnimatableBody2D.position = new_pos
	
	#$Line2D.points[0] = size / 2
	$Line2D.points[1] = $AnimatableBody2D.position - $Line2D.position
	$Line2D2.points[1] = (get_node(linked_pully).global_position) - (global_position)
	
	if abs(move_dir) - 1 > 0 and !pully_sound:
		pully_sound = Global.play_sound(preload("res://audio/GMTK2024_PullyLoop_01.ogg"),global_position)
	elif abs(move_dir) - 1 < 0 and is_instance_valid(pully_sound):
		pully_sound.queue_free()
		pully_sound = null

func _exit_tree() -> void:
	if pully_sound:
		pully_sound.queue_free()

func get_total_weight():
	var total_weight = 0
	for player in colliding_players:
		total_weight += player.get_weight()
	return total_weight * 3
