extends RigidBody2D

var object
var object_size
var screen_size
var object_length
var current_scale
var number_of_objects = 7
var mode


func _ready() -> void:
	
	object = $Sprite2D
	screen_size = get_viewport_rect().size
	object_size = object.texture.get_size()
	object_length = screen_size.x / number_of_objects
	current_scale = object_length / object_size.x
	

func _process(delta: float) -> void:
	scale = Vector2(current_scale, current_scale)
	position = Vector2(object_size.x * current_scale / 2, object_size.y * current_scale / 2)
	$CollisionShape2D.shape.extents = object_size * current_scale / 2


func _on_body_entered(body: Node) -> void:
	print(body)
