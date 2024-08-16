extends CharacterBody2D
class_name Player

@export var size := 4.0

const SPEED = 300.0
const JUMP_VELOCITY = 400.0
const MAX_SIZE = 4.0

var can_control = true
var nearby_parent = null

func _ready() -> void:
	scale = Vector2(size / MAX_SIZE, size / MAX_SIZE)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	if can_control:
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = 0
	
	move_and_slide()

func jump(overide_speed = -1):
	var jump_speed = JUMP_VELOCITY
	if overide_speed > 0:
		jump_speed = overide_speed
	velocity.y = -jump_speed

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and Global.hovered_player:
		can_control = Global.hovered_player == self
	
	if !can_control:
		return
	
	if event.is_action_pressed("pop"):
		if nearby_parent:
			nearby_parent.can_control = true
			queue_free()
			get_viewport().set_input_as_handled()
		elif size > 1:
			var inst = load("res://objects/player.tscn").instantiate()
			inst.size = size-1
			inst.global_position = global_position
			get_parent().add_child(inst)
			inst.jump(400)
			can_control = false
	
	if event.is_action_pressed("jump") and is_on_floor():
		jump()

func _on_mouse_entered() -> void:
	Global.hovered_player = self

func _on_mouse_exited() -> void:
	if Global.hovered_player == self:
		Global.hovered_player = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and body.size == size-1:
		body.nearby_parent = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player and body.size == size-1:
		body.nearby_parent = null
