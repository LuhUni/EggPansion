extends Area2D

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	collision.shape.size = sprite.get_rect().size

func _on_body_entered(body):
	if body.name=="Player" && body.has_method("morrer"):
		body.morrer()
		#body.morrer(Vector2(0, -250))
