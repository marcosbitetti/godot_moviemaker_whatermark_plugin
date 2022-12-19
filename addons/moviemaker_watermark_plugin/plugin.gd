@tool
extends EditorPlugin

const SETTING = "application/plugin/watermark"
const CLASS = "MovieMakerWatermarkPluginRunner"
var control : Button

func _enter_tree():
	control = preload("res://addons/moviemaker_watermark_plugin/control.tscn").instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, control)
	control.connect("toggled", _popup)
	ProjectSettings.set_setting(SETTING, 0)
	add_autoload_singleton(CLASS, "res://addons/moviemaker_watermark_plugin/run.gd")
	if OK != ProjectSettings.save():
		OS.alert("Can't change project setthings", "Error!")

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, control)
	ProjectSettings.set_setting(SETTING, null)
	remove_autoload_singleton(CLASS)
	if OK != ProjectSettings.save():
		OS.alert("Can't change project setthings", "Error!")

func _enable_plugin():
	pass

func _disable_plugin():
	pass

func _popup(_v):
	var pop : PopupMenu = control.get_popup()
	pop.connect("index_pressed", _index)

func _index(i):
	var pop : PopupMenu = control.get_popup()
	pop.disconnect("index_pressed", _index)
	ProjectSettings.set_setting(SETTING, i)
	if OK != ProjectSettings.save():
		OS.alert("Can't change project setthings", "Error!")
	control.text = pop.get_item_text(i)
