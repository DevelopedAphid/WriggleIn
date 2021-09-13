extends Panel

func _ready():
	pass

func _on_BackButton_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainScreen.tscn")


func _on_EnterButton_button_up():
	var text_box = get_node("NameTextEdit")
	var person_name = text_box.text
	
	if person_name != "" && text_box.get_line_count() == 1:
		Global.add_new_person(person_name, "Employee")
	
	text_box.text = ""


func _on_FileDialog_file_selected(path):
	print(path)
	$FileDialog.hide()

func _on_CopyLogsButton_pressed():
	var date = get_node("LogDateTextEdit").text
	OS.set_clipboard(str(Global.in_out_logs.get(str(date))))
