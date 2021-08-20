extends Node2D

var Room = preload("res://level_gen/room_body.tscn")

var num_rooms = 75  # number of rooms to generate
var min_size = 20  # minimum room size (in tiles)
var max_size = 50  # maximum room size (in tiles)

var spread : int = 25 # spread

var cull : float = 0.6 # chance of culling

func _ready():
	randomize()
	make_rooms()

func _process(delta):
	update()

func _input(event):
	if event.is_action_pressed('ui_select'):
		for n in $Rooms.get_children():
			n.queue_free()
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
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		#else:
		#	room.mode = RigidBody2D.MODE_STATIC
