extends StaticBody2D
class_name Door

var open = 0

func toggle_open(new_open):
	if new_open:
		open += 1
	else:
		open -= 1
	
	$CollisionShape2D.disabled = open > 0
	$ColorRect.visible = open <= 0
