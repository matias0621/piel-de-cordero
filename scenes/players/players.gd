extends CharacterBody3D

@export var speed:float = 10
@export var acceleration:float = 20
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var input_dir := Input.get_vector("player_one_right", "player_one_left", "player_one_down", "player_one_up")
	
	if input_dir != Vector2.ZERO:
		velocity.x = lerp(velocity.x, input_dir.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, input_dir.y * speed ,acceleration * delta)
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()
