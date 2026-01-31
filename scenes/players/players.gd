extends CharacterBody3D

class_name Player

@export var speed: float = 10
@export var acceleration: float = 20
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var device_id:int = -1

# Reference the mask that is already a child of the player
@onready var mask_node = $Mask 
var is_mask_thrown: bool = false

func _ready() -> void:
	print(device_id)

func _physics_process(delta: float) -> void:
	# 1. Gravity is always active
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Get Input (Always check for the throw button)
	var input_dir := Input.get_vector("player_one_right", "player_one_left", "player_one_down", "player_one_up")

	if Input.is_action_just_pressed("player_one_throw_mask") and not is_mask_thrown:
		_throw_mask()

	# 3. Movement Logic
	if not is_mask_thrown:
		# Normal movement when mask is ON the player
		if input_dir.length() > 0.1:
			velocity.x = lerp(velocity.x, input_dir.x * speed, acceleration * delta)
			velocity.z = lerp(velocity.z, input_dir.y * speed, acceleration * delta)

			var movement_direction = Vector3(-input_dir.x, 0, -input_dir.y).normalized()
			look_at(global_transform.origin + movement_direction, Vector3.UP)
		else:
			velocity.x = move_toward(velocity.x, 0, acceleration * delta)
			velocity.z = move_toward(velocity.z, 0, acceleration * delta)
	else:
		# Stop moving while throwing/returning
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0, acceleration * delta)

	move_and_slide()

func _throw_mask():
	is_mask_thrown = true
	
	# 1. Detach from player and add to the world so it doesn't move WITH the player
	var world = get_parent()
	var start_pos = mask_node.global_position
	remove_child(mask_node)
	world.add_child(mask_node)
	mask_node.global_position = start_pos

	# 2. Logic for throwing
	var throw_distance = 10
	var target_position = global_transform.origin + global_transform.basis.z * throw_distance

	while mask_node.global_position.distance_to(target_position) > 0.1:
		mask_node.global_position = mask_node.global_position.move_toward(target_position, 20 * get_process_delta_time())
		await get_tree().process_frame

	await get_tree().create_timer(1.0).timeout
	_return_mask()

func _return_mask():
	mask_node.set_collision_layer(0)
	mask_node.set_collision_mask(0)

	while mask_node.global_position.distance_to(global_transform.origin) > 0.5:
		# Move toward the player's current position
		mask_node.global_position = mask_node.global_position.move_toward(global_transform.origin, 25 * get_process_delta_time())
		await get_tree().process_frame

	# 3. Re-attach to player and reset local position
	mask_node.get_parent().remove_child(mask_node)
	add_child(mask_node)
	
	# Reset to your specific coordinates
	mask_node.position = Vector3(0, 0.5, 0.5)
	mask_node.rotation = Vector3.ZERO
	
	mask_node.set_collision_layer(1)
	mask_node.set_collision_mask(1)
	is_mask_thrown = false

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
