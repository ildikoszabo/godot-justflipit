class_name PancakeFlat extends Area2D

signal pancake_position_changed
signal is_pancake_moving

var weight:int = 10
var customGravity:int = 10
var current_speed:float = 0.0
var target_up_speed:float = 10.0
var speed_turning_point = 12.0 #it should start falling after this speed
var target_down_speed:float = 0.0
var lerp_speed = 0.1 # Adjust for smoothness
var fall_speed = 0.0
var fall_speed_constant = 50
var shouldBeMoving:bool = false
var isMoving: bool = false
var spawnPosition:Vector2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	spawnPosition = global_position

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO 
	if (shouldBeMoving):
		direction.y -= 1
		if direction != Vector2.ZERO:
			current_speed = lerp(current_speed, target_up_speed, lerp_speed)			
			direction = direction.normalized()
			global_position += direction * current_speed * delta			
			pancake_position_changed.emit(global_position)					
	elif fall_speed > 1.0:
			#global_position = lerp(global_position, spawnPosition, fall_speed * delta)
			#global_position = global_position.move_toward(spawnPosition, fall_speed * delta)
		direction.y += 1	
		if direction != Vector2.ZERO:
			fall_speed = lerp(fall_speed, target_down_speed, lerp_speed)				
			direction = direction.normalized()
			#global_position += direction * fall_speed * delta
			global_position = global_position.move_toward(spawnPosition, fall_speed * delta)
			pancake_position_changed.emit(global_position)			
	
	if current_speed < speed_turning_point:
		shouldBeMoving = false
		is_pancake_moving.emit(false)
	
	if direction.length() > 0:		
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if direction.y == -1:
		$AnimatedSprite2D.animation = &"moving"
		rotation = PI if direction.y > 0 else 0
		$AnimatedSprite2D.flip_v = false
	
	elif direction.y == 1:
		$AnimatedSprite2D.animation = &"moving"		
		$AnimatedSprite2D.flip_v = true			
	else:
		$AnimatedSprite2D.animation = &"flat"
	
		


func _throw(speed):
	var direction = Vector2.ZERO 
	direction.y -= 1
	global_position = lerp(global_position, Vector2(100,31), 0.5)
	shouldBeMoving = false
	is_pancake_moving.emit(false)

func _set_should_move(shouldMove:bool, newspeed):
	shouldBeMoving = shouldMove
	current_speed = newspeed
	fall_speed = newspeed + fall_speed_constant #should come down harder than it goes up
	is_pancake_moving.emit(shouldMove)
