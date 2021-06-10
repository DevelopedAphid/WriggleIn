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

func _update_tree():
	tree.clear()
	#Tree needs a root otherwise first TreeItem added becomes the root by default
	var _root: TreeItem = tree.create_item()
	
	for n in Global.person_dict.size():
		var current_person = Global.person_dict[n]
		if current_person.Type == "Employee":
			var current_tree_item: TreeItem = tree.create_item()
			current_tree_item.set_icon(0,load("res://art/person.svg"))
			current_tree_item.set_text(1,current_person.Name)
			current_tree_item.add_button(2, load("res://art/bin.svg"))
			current_tree_item.set_text(3, str(current_person.ID))


func _on_AdminTree_button_pressed(item, _column, _id):
	var person_id = item.get_text(3)
	Global.remove_a_person(int(person_id))
