extends StaticBody2D
class_name Door

var open = 0

func toggle_open(new_open):
	if new_open:
		open += 1
	else:
		open -= 1
	
	$CollisionShape2D.disabled = open > 0
	if new_open and open == 1:
		$AnimatedSprite2D.play("open")
	elif !new_open and open == 0:
		$AnimatedSprite2D.play_backwards("open")
