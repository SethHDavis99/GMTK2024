extends Node2D

@export var travel_length := 300.0
@export var travel_time := 5.0
@export var is_horizontal := true
var position_timer = 0
var travel_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	travel_speed = travel_length / travel_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position_timer += delta
	if position_timer > travel_time:
		position_timer = 0
		travel_speed = -travel_speed
	
	if is_horizontal:
		$RigidBody2D.set_axis_velocity(Vector2(travel_speed, 0))
	else:
		$RigidBody2D.set_axis_velocity(Vector2(0, travel_speed))
