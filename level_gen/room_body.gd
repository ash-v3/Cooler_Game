extends StaticBody2D

func _ready():
	pass

func make_room(pos, size):
	var s = RectangleShape2D.new()
	s.extents = size
	
	$CollisionShape2D.shape = s
