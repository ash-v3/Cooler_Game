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
