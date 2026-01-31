class_name Player
extends CharacterBody3D

@export var speed:float = 10
@export var acceleration:float = 20
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var device_id:int = -1

func _ready() -> void:
	print(device_id)

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = MultiplayerInput.get_vector(device_id ,"player_one_right", "player_one_left", "player_one_down", "player_one_up")
	
	if input_dir != Vector2.ZERO:
		velocity.x = lerp(velocity.x, input_dir.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, input_dir.y * speed ,acceleration * delta)
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()


func _test():
	var dir:Vector3 = Vector3.ZERO
	
	if Input.get_action_strength("player_one_right", device_id) > 0:
		dir.x += 1
	
	if Input.get_action_strength("player_one_left", device_id) > 0:
		dir.x -= 1
	
	if Input.get_action_strength("player_one_down", device_id) > 0:
		dir.z += 1
	
	if Input.get_action_strength("player_one_up", device_id) > 0:
		dir.z -= 1
	
	var dir_normal:Vector3 = dir.normalized()
	velocity.x = dir_normal.x * speed
	velocity.z = dir_normal.z * speed 
	
	move_and_slide()
