extends Tree

func _ready():
	var tree: Tree = self
	tree.select_mode = 1
	tree.hide_root = true
	
	#Tree needs a root otherwise first TreeItem added becomes the root by default
	var _root: TreeItem = tree.create_item()
	
	for n in Global.person_dict.size():
		var current_tree_item: TreeItem = tree.create_item()
		current_tree_item.set_text(0,Global.person_dict[n].Name)
		current_tree_item.set_text(1,Global.person_dict[n].Status)
		current_tree_item.set_text(2,Global.person_dict[n].Time_status_changed)
		current_tree_item.add_button(3, load("res://icon.png"))
		
	
	print(tree.get_root())


func _on_EmployeeTree_button_pressed(item, column, id):
	item.set_button(column, id, load("res://icon_red.png"))
	print(item)
	#TODO: sets in/out status with Global func - and icon status determined by in/out status
