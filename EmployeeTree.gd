extends Tree

var tree: Tree = self

func _ready():
	tree.select_mode = 1
	tree.hide_root = true
	tree.columns = 6
	
	#Tree needs a root otherwise first TreeItem added becomes the root by default
	var _root: TreeItem = tree.create_item()
	
	_update_tree()
	
# warning-ignore:return_value_discarded
	Global.connect("person_list_changed", self, "_on_Global_person_list_changed")

func _on_Global_person_list_changed():
	_update_tree()

func _on_EmployeeTree_button_pressed(item, column, id):
	var person_id = item.get_text(5)
	#TODO this breaks because I don't have an ID number anymore - need to use dictionary key but not sure how to do that...
	var new_status = Global.change_person_status(person_id)
	
	item.set_text(2,new_status)
	item.set_text(3,Global.people_dict.get(person_id).Time_status_changed)
	
	if new_status == "in":
		item.set_button(column, id, load("res://art/office_small.svg"))
	elif new_status == "out":
		item.set_button(column, id, load("res://art/waving_hand.svg"))

func _update_tree():
	tree.clear()
	#Tree needs a root otherwise first TreeItem added becomes the root by default
	var _root: TreeItem = tree.create_item()
	
	for n in Global.people_dict:
		var current_person = Global.get_person(n)
		if Global.status_to_show == "all" && Global.person_type_to_show == "all":
			load_person_into_tree(current_person, n)
		elif Global.status_to_show == "all":
			if current_person.Type == Global.person_type_to_show:
				load_person_into_tree(current_person, n)
		else:
			if current_person.Status == Global.status_to_show && current_person.Type == Global.person_type_to_show:
				load_person_into_tree(current_person, n)

func load_person_into_tree(current_person, person_count):
	var current_tree_item: TreeItem = tree.create_item()
	current_tree_item.set_icon(0,load("res://art/person_small.svg"))
	current_tree_item.set_text(1,current_person.Name)
	current_tree_item.set_text(2,current_person.Status)
	current_tree_item.set_text(3,current_person.Time_status_changed)
	if current_person.Status == "in":
		current_tree_item.add_button(4, load("res://art/office_small.svg"))
	elif current_person.Status == "out":
		current_tree_item.add_button(4, load("res://art/house_small.svg"))
	current_tree_item.set_text(5,person_count)
