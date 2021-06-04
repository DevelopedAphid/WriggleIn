extends ItemList

signal employee_added(employee_id)

func _ready():
	for n in Global.person_dict.size():
		if Global.person_dict[n].Type == "Employee":
			add_item(str(Global.person_dict[n].Name))
			emit_signal("employee_added", n)
	
