extends Node2D

@export var next_scene : String = ""

@onready var player := $Player as CharacterBody2D
@onready var playerScene = preload("res://PackedScenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_title(self.name)




func _on_door_body_entered(body):
	if body.name=="Player":
		Globals.aumentar_tela()
		get_tree().change_scene_to_file(next_scene) == OK
