extends Node2D

var Room = preload("res://level_gen/room_body.tscn")

var num_rooms = 75  # number of rooms to generate
var min_size = 20  # minimum room size (in tiles)
var max_size = 50  # maximum room size (in tiles)

var spread : int = 25 # spread

var cull : float = 0.6 # chance of culling

var path #AStar pathfinding object

func _ready():
	make_rooms()

func _process(delta):
	update()

func _draw():
	draw_set_transform($Rooms.position, 0, Vector2(1, 1))

	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size*2),
					Color(0, 1, 0), false)
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y),
							Vector2(cp.x, cp.y),
							Color(1, 1, 0, 1), 15, true)

func _input(event):
	if event.is_action_pressed('ui_select'):
		for room in $Rooms.get_children():
			room.queue_free()
		make_rooms()

func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(TB.randi_range(-spread, spread), TB.randi_range(-spread, spread))
		
		var r = Room.instance()
		var w = TB.randi_range(min_size, max_size)
		var h = TB.randi_range(min_size, max_size)
		r.make_room(pos, Vector2(w, h))
		$Rooms.add_child(r)
		
	# wait for movement to stop, yield to a timer that will return when done
	yield(get_tree().create_timer(1.5), 'timeout')
	
	# cull rooms
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x, room.position.y, 0))
		
	yield(get_tree(), 'idle_frame')

	# generate spanning tree (path)
	path = TB.find_mst(room_positions)

func get_rooms():
	var rooms = []
	for room in $Rooms.get_children():
		rooms.append({"x": room.position.x, "y": room.position.y, "w": room.size.x, "h": room.size.y})
	
	return rooms
