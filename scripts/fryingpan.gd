class_name FryingPan extends CharacterBody2D

var isSelected: bool = false
var restZones = []
var currentRestZone
var pancake : Node2D 

func _ready():
	restZones = get_tree().get_nodes_in_group("returnZone")
	pancake = get_parent().get_node("Pancake")
	currentRestZone = restZones[0].global_position

func _process(delta: float) -> void:
	if isSelected:
		$Sprite2D.scale = Vector2(5.725,1.50)	
	else:
		$Sprite2D.scale = Vector2(5.425,1)

func _physics_process(delta):
	if isSelected:
		global_position = lerp(global_position, get_global_mouse_position(), 10*delta)
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal(), 300)
	else:
		global_position = lerp(global_position, currentRestZone, 5*delta)
		

		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			isSelected = true
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			isSelected = false

func _on_mouse_entered() -> void:	
	$Sprite2D.scale = Vector2(5.725,1.50)	

func _on_mouse_exited() -> void:	
	$Sprite2D.scale = Vector2(5.425,1)
	
	
