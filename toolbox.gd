extends Node

func test():
	pass
	
func randi_range(min_i : int, max_i : int):
	var size :int = max_i - min_i
	var r : int = randi() % (size + 1) + min_i
	return r
	
func choose(ops):
	if type(ops) == "Dictionary":
		ops = to_array(ops)
	var i = randi_range(0, len(ops) - 1)
	return ops[i]

func type(v):
	var i = typeof(v)
	var types = ["nil", "bool", "int", "float", "String", "Vector2", "Rect2", "Vector3", "Transform2D", "Plane", "Quat", "AABB", "Basis", "Transform", "Color", "NodePath", "RID", "Object", "Dictionary", "Array"]
	
	if i == 17:
		return v.type_of()
	else:
		return types[i]

func to_array(d):
	var a = []
	for v in d:
		a.append(v)
	return a

func find_mst(nodes):
	# Prim's algorithm
    # Given an array of positions (nodes), generates a minimum spanning tree
    # Returns an AStar object

    # Initialize the AStar and add the first point
    var path = AStar.new()
    path.add_point(path.get_available_point_id(), nodes.pop_front())

    # Repeat until no more nodes remain
    while nodes:
        var min_dist = INF  # Minimum distance between any path node and any other node
        var min_p = null  # Position of other node
        var p = null  # Position on path closest to other node

        # Loop through the points in the path
        for p1 in path.get_points():
            p1 = path.get_point_position(p1)

			# Loop through the remaining nodes in the given array
            for p2 in nodes:
                # If the node is closer, make it the closest
                if p1.distance_to(p2) < min_dist:
                    min_dist = p1.distance_to(p2)
                    min_p = p2
                    p = p1

		# Insert the resulting node into the path and add its connection
        var n = path.get_available_point_id()
        path.add_point(n, min_p)
		# why get_closest_point()?
        path.connect_points(path.get_closest_point(p), n)
        
		# Remove the node from the array so it isn't visited again
        nodes.erase(min_p)

    return path