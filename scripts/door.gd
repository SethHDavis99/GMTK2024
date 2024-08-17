extends StaticBody2D
class_name Door

var open = false

func toggle_open(new_open):
	if new_open != open:
		open = new_open
		$CollisionShape2D.disabled = open
		$ColorRect.visible = !open
