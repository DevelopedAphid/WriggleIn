extends Tree

var tree: Tree = self
var status_to_show: String = "all"

func _ready():
	tree.select_mode = 1
	tree.hide_root = true
	tree.columns = 6
	
	#Tree needs a root otherwise first TreeItem added becomes the root by default
	var _root: TreeItem = tree.create_item()
	
	_update_tree()
	
	Global.connect("person_list_changed", self, "_on_Global_person_list_changed")
	Global.connect("status_to_show_changed", self, "_on_Global_status_to_show_changed")

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
		var current_person = Global.person_dict[n]
		if status_to_show == "all":
			load_person_into_tree(current_person)
		else:
			if current_person.Status == status_to_show:
				load_person_into_tree(current_person)

func load_person_into_tree(current_person):
	var current_tree_item: TreeItem = tree.create_item()
	current_tree_item.set_icon(0,load("res://icon.png"))
	current_tree_item.set_text(1,current_person.Name)
	current_tree_item.set_text(2,current_person.Status)
	current_tree_item.set_text(3,current_person.Time_status_changed)
	if current_person.Status == "in":
		current_tree_item.add_button(4, load("res://icon.png"))
	elif current_person.Status == "out":
		current_tree_item.add_button(4, load("res://icon_red.png"))
	current_tree_item.set_text(5, str(current_person.ID))

func _on_Global_status_to_show_changed(new_status):
	print(new_status)
	status_to_show = new_status
	_update_tree()
