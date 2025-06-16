class_name Pancake extends RigidBody2D

var fryingPan : Node2D 
var reset_state = false
var moveVector: Vector2
var spawnPosition : Vector2

func _ready() -> void:
	fryingPan = get_parent().get_node("FryingPan")
	spawnPosition = global_position


func _process(delta: float) -> void:	
	if (fryingPan != null && global_position.y > fryingPan.position.y):		
		#move_body(fryingPan.position)
		move_body(spawnPosition)
		

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#if abs(linear_velocity.x) < 0.1 and abs(linear_velocity.y) < 0.1:
	#	linear_velocity = Vector2.ZERO
	if reset_state:
		state.transform = Transform2D(0.0, moveVector)
		reset_state = false
		

func move_body(targetPos: Vector2):
	moveVector = targetPos;
	reset_state = true;
	linear_velocity = Vector2.ZERO
	angular_velocity = 0


func _on_body_entered(body: Node) -> void:
	move_body(spawnPosition)
