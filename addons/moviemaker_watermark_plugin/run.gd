extends Node

const SETTING = "application/plugin_watermark"
const M = 8

func _ready():
	call_deferred("_start")

func _start():
	print("starte")
	var tex : CompressedTexture2D = ResourceLoader.load("res://addons/moviemaker_watermark_plugin/art/mark.webp", "CompressedTexture2D")
	var image : TextureRect = TextureRect.new()
	image.ignore_texture_size = false
	image.texture = tex
	image.size = Vector2(tex.get_width(), tex.get_height())
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if ProjectSettings.get_setting(SETTING) == 1:
		image.position = Vector2(get_tree().root.get_visible_rect().size.x - image.size.x - M, M)
	elif ProjectSettings.get_setting(SETTING) == 2:
		image.position = Vector2(8, get_tree().root.get_visible_rect().size.y - image.size.y - M)
	elif ProjectSettings.get_setting(SETTING) == 3:
		image.position = get_tree().root.get_visible_rect().size - image.size - Vector2(M,M)
	else:
		image.position = Vector2(M,M)
	get_tree().root.get_child(get_tree().root.get_child_count() - 1).add_child(image)
	get_tree().create_tween().tween_property(image, "modulate", Color(1,1,1,1), .8).from(Color(1,1,1,0))
