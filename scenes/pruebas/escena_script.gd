# extends Node

# # Reference the player node (red capsule)
# @onready var player = $Players

# # Reference the thrown object (white cube)
# @onready var thrown_object = $Players/CharacterBody3D/ThrownObject

# func throw_object() -> void:
# 	print("Throwing object")
# 	# Detach the thrown object from the player
# 	$Players/CharacterBody3D.remove_child(thrown_object)

# 	# Set the initial position of the thrown object to the player's position
# 	thrown_object.global_transform.origin = $Players/CharacterBody3D.global_transform.origin

# 	# Set the direction of the thrown object based on the player's facing direction
# 	var direction = $Players/CharacterBody3D.global_transform.basis.z.normalized()
# 	thrown_object.linear_velocity = direction * 20  # Adjust speed as needed

# 	# Add the thrown object to the parent node for independent movement
# 	get_parent().add_child(thrown_object)

# 	# Schedule the object to return after 1 second
# 	await get_tree().create_timer(1.0).timeout

# 	# Return the object to the player
# 	get_parent().remove_child(thrown_object)
# 	$Players/CharacterBody3D.add_child(thrown_object)
# 	thrown_object.global_transform.origin = $Players/CharacterBody3D.global_transform.origin

# func _process(_delta: float) -> void:
# 	print(Input.is_action_just_pressed("ui_accept"))
# 	if Input.is_action_just_pressed("ui_accept"):
# 		throw_object()
