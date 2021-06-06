extends Tree

var tree: Tree = self

func _ready():
	tree.select_mode = 1
	tree.hide_root = true
	tree.columns = 5
	
	#Tree needs a root otherwise first TreeItem added becomes the root by default
	var _root: TreeItem = tree.create_item()
	
	Global.connect("person_added", self, "_on_Global_person_added")
	
	for n in Global.person_dict.size():
		var current_tree_item: TreeItem = tree.create_item()
		current_tree_item.set_text(0,Global.person_dict[n].Name)
		current_tree_item.set_text(1,Global.person_dict[n].Status)
		current_tree_item.set_text(2,Global.person_dict[n].Time_status_changed)
		if Global.person_dict[n].Status == "in":
			current_tree_item.add_button(3, load("res://icon.png"))
		elif Global.person_dict[n].Status == "out":
			current_tree_item.add_button(3, load("res://icon_red.png"))
		current_tree_item.set_text(4, str(Global.person_dict[n].ID))
	
	print(tree.get_root())


func _on_EmployeeTree_button_pressed(item, column, id):
	var person_id = int(item.get_text(4))
	var new_status = Global.change_person_status(person_id)
	
	item.set_text(1,new_status)
	item.set_text(2,Global.person_dict[person_id].Time_status_changed)
	
	if new_status == "in":
		item.set_button(column, id, load("res://icon.png"))
	elif new_status == "out":
		item.set_button(column, id, load("res://icon_red.png"))
	

func _on_Global_person_added():
	_update_tree()
	
func _update_tree():
		for n in Global.person_dict.size():
			var current_tree_item: TreeItem = tree.create_item()
			current_tree_item.set_text(0,Global.person_dict[n].Name)
			current_tree_item.set_text(1,Global.person_dict[n].Status)
			current_tree_item.set_text(2,Global.person_dict[n].Time_status_changed)
			if Global.person_dict[n].Status == "in":
				current_tree_item.add_button(3, load("res://icon.png"))
			elif Global.person_dict[n].Status == "out":
				current_tree_item.add_button(3, load("res://icon_red.png"))
			current_tree_item.set_text(4, str(Global.person_dict[n].ID))
