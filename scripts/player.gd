extends CharacterBody2D
class_name Player

@export var size := 3.0

const SPEED = 300.0
const JUMP_VELOCITY = 300.0
const JUMP_MOD = 90.0
const MAX_SIZE = 4.0
var can_control = true
var nearby_parent = null
var nearby_pully = null
var playing_popin = false
var coyote_finished = false
var footstep = null
var landed = false

func _ready() -> void:
	Global.selected_player = self
	Global.players[size] = self
	scale = Vector2(size / MAX_SIZE, size / MAX_SIZE)
	MusicSystem.toggle_music(size,true)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if $CoyoteTime.is_stopped() and !coyote_finished:
			$CoyoteTime.start()
		if landed:
			landed = false
			$AnimatedSprite2D.play("JumpUp")
	elif velocity.y == 0:
		if not landed:
			footstep = Global.play_sound(preload("res://audio/GMTK2024_FootStep_02.ogg"),global_position,[0.8,1.2])
			#$FallingVFX/GPUParticles2D.emitting = true
			#$FallingVFX/GPUParticles2D2.emitting = true
			$AnimatedSprite2D.play("IDLE")
		coyote_finished = false
		$CoyoteTime.stop()
		landed = true
	
	# Get the input direction and handle the movement/deceleration.
	if can_control:
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.flip_h = direction < 0
			if is_on_floor() and velocity.y == 0:
				$AnimatedSprite2D.play("R_Walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor() and velocity.y == 0 and Global.selected_player == self:
				$AnimatedSprite2D.play("IDLE")
	else:
		velocity.x = 0
	
	move_and_slide()
	
	# pully systemd
	var recent_pully = null
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision:
			#if collision.get_collider() is Player and collision.get_collider().size < size:
				#collision.get_collider().queue_free()
			if collision.get_collider().get_parent() is PullyPlatform:
				recent_pully = collision.get_collider().get_parent()
	if !recent_pully and nearby_pully:
		nearby_pully.colliding_players.erase(self)
		nearby_pully = null
	elif recent_pully and !nearby_pully:
		nearby_pully = recent_pully
		recent_pully.colliding_players.append(self)
	
	#walk sounds
	if !is_instance_valid(footstep) and $AnimatedSprite2D.animation == "R_Walk" and $AnimatedSprite2D.frame == 5:
		footstep = Global.play_sound(preload("res://audio/GMTK2024_FootStep_02.ogg"),global_position,[0.8,1.2])

func jump(overide_speed = -1):
	coyote_finished = true
	$AnimatedSprite2D.play("JumpUp")
	var jump_speed = JUMP_VELOCITY
	if overide_speed > 0:
		jump_speed = overide_speed
	velocity.y = (jump_speed + (JUMP_MOD * (MAX_SIZE - size))) * -1

func _unhandled_input(event: InputEvent) -> void:
	if playing_popin:
		return
	
	if event.is_action_pressed("click") and Global.hovered_player and !Global.hovered_player.playing_popin:
		Global.selected_player = Global.hovered_player
		can_control = Global.hovered_player == self
		if Global.selected_player:
			Global.play_sound(preload("res://audio/GMTK2024_UI_ButtonConfirm_01.ogg"),global_position)
	
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	
	if !can_control:
		return
	
	if event.is_action_pressed("pop"):
		if nearby_parent:
			Global.selected_player = nearby_parent
			nearby_parent.get_node("AnimatedSprite2D").play("R_OpenUp")
			get_viewport().set_input_as_handled()
			Global.play_sound(preload("res://audio/GMTK2024_DollOpen_01.ogg"),global_position, [MAX_SIZE / size,MAX_SIZE / size])
			can_control = false
			var tween = get_tree().create_tween()
			tween.tween_property(self,"global_position",nearby_parent.global_position - Vector2(0,50 * nearby_parent.scale.x),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.finished.connect(on_tween_finished)
			set_physics_process(false)
			playing_popin = true
			$AnimatedSprite2D.play("IDLE")
		
		elif size > 1 and !Global.players.has(size-1):
			var inst = load("res://objects/player.tscn").instantiate()
			inst.size = size-1
			inst.global_position = global_position
			get_parent().add_child(inst)
			inst.jump(200)
			can_control = false
			Global.play_sound(preload("res://audio/GMTK2024_DollOpen_01.ogg"),global_position,[MAX_SIZE / size,MAX_SIZE / size])
			$AnimatedSprite2D.play("R_OpenUp")
			$JumpOut/GPUParticles2D.emitting = true
	
	if event.is_action_pressed("jump") and can_jump():
		Global.play_sound(preload("res://audio/GMTK2024_Jump_01.ogg"),global_position)
		jump()
	
	if is_on_floor() and (event.is_action_released("move_left") or event.is_action_released("move_right")):
		footstep = Global.play_sound(preload("res://audio/GMTK2024_FootStep_02.ogg"),global_position,[0.8,1.2])

func _exit_tree() -> void:
	Global.players.erase(size)
	MusicSystem.toggle_music(size,false)
	if nearby_pully:
		nearby_pully.colliding_players.erase(self)

func _on_mouse_entered() -> void:
	Global.set_hovered_player(self)

func _on_mouse_exited() -> void:
	if Global.hovered_player == self:
		Global.set_hovered_player(null)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and body.size == size-1:
		body.nearby_parent = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player and body.size == size-1:
		body.nearby_parent = null

func get_weight():
	var weight = size
	for i in range(size-1,0,-1):
		if not Global.players.has(float(i)):
			weight += i
		else:
			break
	return weight

func _on_spawn_timer_timeout() -> void:
	z_index = -int(size) + 100

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "R_OpenUp":
		if Global.selected_player == self:
			can_control = true

func on_tween_finished():
	z_index = 0
	$PopinTimer.start()

func _on_popin_timer_timeout() -> void:
	queue_free()

func can_jump():
	return is_on_floor() or (!$CoyoteTime.is_stopped() and !coyote_finished)

func _on_coyote_time_timeout() -> void:
	coyote_finished = true
