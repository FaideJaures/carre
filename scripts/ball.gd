extends Area2D
signal hit

@export var speed = 400
var screen_size
var object_length
var bound_x
var bound_y
var arrow
var move = false
var click_x = 0
var click_y = 0
var velocity

func _ready() -> void:
	var object = $Sprite2D
	var object_size = object.texture.get_size()
	
	arrow = $arrow
	object_length = 20
	screen_size = get_viewport_rect().size
	bound_x = Vector2(float(object_length) / 2, screen_size.x - object_length / 2)
	bound_y = Vector2(float(object_length) / 2, screen_size.y - float(object_length) / 2)
	
	
	scale = Vector2(object_length, object_length) / Vector2(object_size)
	
	var initial_position = Vector2(float(screen_size.x) / 2, screen_size.y - float(object_length) / 2)
	
	position = initial_position
	


func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	arrow.rotation = -(deg_to_rad(-90) + calculate_angle(mouse_pos, position, screen_size))
	
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right") and !move:
		velocity.x += 1
	
	if Input.is_action_pressed("move_left") and !move:
		velocity.x -= 1
	
	if Input.is_action_just_pressed("click") and !move:
		mouse_pos = mouse_pos - position
		click_x = mouse_pos[0]
		click_y = mouse_pos[1]
		move = true
	
	
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	if move:
		position += Vector2(click_x, click_y).normalized() * speed * delta
		
		arrow.hide()
		
		if position.x <= bound_x.x or position.x > bound_x.y:
			click_x *= -1
		if position.y <= bound_y.x:
			click_y *= -1
		if  position.y >= bound_y.y:
			move = !move
			arrow.show()
	else:
		position += velocity.normalized() * speed/2 * delta

	
	position = position.clamp(Vector2(bound_x.x, bound_y.x), Vector2(bound_x.y, bound_y.y))


func calculate_angle(A: Vector2, O: Vector2, B: Vector2) -> float:
	var AO = A - O
	var OB = B - O
	var dot_product = AO.dot(OB)
	var magnitude_product = AO.length() * OB.length()
	
	if magnitude_product == 0:
		return 0
	
	var cos_theta = dot_product / magnitude_product
	return acos(cos_theta)


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	print("k")
