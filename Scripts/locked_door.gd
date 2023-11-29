extends CharacterBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite = $Sprite2D

var is_open :=false

func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if !is_open:
		return
	queue_free()

