extends ConfirmationDialog

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)

func _input(event : InputEvent) -> void:
	if event.is_action_released("quit_game"):
		if is_visible_in_tree():
			hide()
		else:
			popup()
			

func _notification(what : int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		popup()

func _on_quit_confirm_box_confirmed() -> void:
	get_tree().quit()


func _on_quit_confirm_box_popup_hide() -> void:
	get_tree().set_pause(false)


func _on_quit_confirm_box_about_to_show() -> void:
	get_tree().set_pause(true)
