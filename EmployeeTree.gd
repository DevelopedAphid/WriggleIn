extends Tree

var tree: Tree = self

func _ready():
	tree.select_mode = 1
	tree.hide_root = true
	tree.columns = 6
	
	#Tree needs a root otherwise first TreeItem added becomes the root by default
	var _root: TreeItem = tree.create_item()
	
	_update_tree()
	
	Global.connect("person_list_changed", self, "_on_Global_person_list_changed")

func _on_Global_person_list_changed():
	_update_tree()

func _on_EmployeeTree_button_pressed(item, column, id):
	var person_id = int(item.get_text(5))
	var new_status = Global.change_person_status(person_id)
	
	item.set_text(2,new_status)
	item.set_text(3,Global.person_dict[person_id].Time_status_changed)
	
	if new_status == "in":
		item.set_button(column, id, load("res://icon.png"))
	elif new_status == "out":
		item.set_button(column, id, load("res://icon_red.png"))

	
func _update_tree():
	tree.clear()
	#Tree needs a root otherwise first TreeItem added becomes the root by default
	var _root: TreeItem = tree.create_item()
	
	for n in Global.person_dict.size():
		var current_tree_item: TreeItem = tree.create_item()
		current_tree_item.set_icon(0,load("res://icon.png"))
		current_tree_item.set_text(1,Global.person_dict[n].Name)
		current_tree_item.set_text(2,Global.person_dict[n].Status)
		current_tree_item.set_text(3,Global.person_dict[n].Time_status_changed)
		if Global.person_dict[n].Status == "in":
			current_tree_item.add_button(4, load("res://icon.png"))
		elif Global.person_dict[n].Status == "out":
			current_tree_item.add_button(4, load("res://icon_red.png"))
		current_tree_item.set_text(5, str(Global.person_dict[n].ID))
