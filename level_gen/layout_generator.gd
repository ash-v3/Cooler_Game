extends Node2D

var Room = preload("res://level_gen/room_body.tscn")

var tile_size = 32  # size of a tile in the TileMap
var num_rooms = 50  # number of rooms to generate
var min_size = 1  # minimum room size (in tiles)
var max_size = 4  # maximum room size (in tiles)

var hspread = 400 # horizontal spread

func _ready():
	randomize()
	make_rooms()

func _process(delta):
	update()
	
func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.get_global_position() - room.size, room.size*2),
				Color(32, 228, 0), false)

func _input(event):
	if event.is_action_pressed('ui_select'):
		for n in $Rooms.get_children():
			n.queue_free()
		make_rooms()

func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(0, 0)
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
