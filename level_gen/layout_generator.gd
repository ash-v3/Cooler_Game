extends Node2D

var grid_pixel_size

func _ready():
	generate_rooms(20, 25, 20, 20)

func generate_rooms(rooms, dist, min_size, max_size):
	# Build the physics bodies for rooms
	for i in range(rooms):
		var pos = Vector2(TB.randi_range(-dist, dist), TB.randi_range(-dist, dist))
		var w = TB.randi_range(min_size, max_size)
		var h = TB.randi_range(min_size, max_size)
		
		var room = preload("res://level_gen/room_body.tscn").instance()

		room.transform.origin = pos
		
		$Rooms.add_child(room)

	# Place them near the middle and displace

	# Let it run for arbitrary time
	
	# Record the size and position of all physics bodies

	# Return result as array
