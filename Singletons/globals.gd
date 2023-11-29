extends Node


var viewport_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))

func _ready():
	center_window()

func _process(delta):
	pass

func aumentar_tela():
	viewport_size+=Vector2(102.4,57.6)
	get_viewport().size = viewport_size
	center_window()
	
func center_window() -> void:
	var window = get_window() # Get the current window
	var screen = window.current_screen # And get the current screen the window's in
	var screen_rect = DisplayServer.screen_get_usable_rect(screen) # Get the usable rect for that screen
	var window_size = window.get_size_with_decorations() # Get the window's size
	
	window.position = screen_rect.position + (screen_rect.size / 2 - window_size / 2)# Set its position to the middle

func restart():
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
