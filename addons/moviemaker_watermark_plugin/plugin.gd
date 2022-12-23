@tool
extends EditorPlugin

const SETTING = "application/plugin_watermark"
const CLASS = "MovieMakerWatermarkPluginRunner"
var control : Button

func _enter_tree():
	await get_tree().create_timer(.4).timeout
	control = preload("res://addons/moviemaker_watermark_plugin/control.tscn").instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, control)
	control.connect("toggled", _popup)
	add_autoload_singleton(CLASS, "res://addons/moviemaker_watermark_plugin/run.gd")
	var setting = get_config_in_project()
	if setting > -1:
		control.text = {
			0: "Top Left",
			1: "Top Right",
			2: "Bottom Left",
			3: "Bottom Right",
		}[setting]
		return

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, control)

func _enable_plugin():
	ProjectSettings.set_setting(SETTING, 0)
	if OK != ProjectSettings.save():
		OS.alert("Can't change project setthings", "Error!")

func _disable_plugin():
	ProjectSettings.set_setting(SETTING, null)
	remove_autoload_singleton(CLASS)
	if OK != ProjectSettings.save():
		OS.alert("Can't change project setthings", "Error!")

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

func get_config_in_project() -> int :
	var path = ProjectSettings.globalize_path(get_tree().edited_scene_root.scene_file_path).get_base_dir()
	path += "/project.godot"
	var cfg : ConfigFile = ConfigFile.new()
	if OK != cfg.load(path):
		OS.alert("cant open " + path, "Error!")
	var val = cfg.get_value("application", "plugin_watermark", -1)
	return val
