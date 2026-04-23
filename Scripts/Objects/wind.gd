extends Node2D

class_name wind

# Detects bodies in wind
@onready var AREA = $Area2D

func _process(_delta):
	# Find wind direction
	var dir_x = $"Sprite End".global_position.x - $"Sprite Body".global_position.x
	var dir_y = $"Sprite End".global_position.y - $"Sprite Body".global_position.y
	var DIRECTION : Vector2 = Vector2(dir_x,dir_y)
	
	for body in AREA.get_overlapping_bodies():
		if body is RigidBody2D or body is CharacterBody2D:
			# Check for attributes
			## Weight. Default of 1
			var weight : float = 1
			## If on floor. Default of false
			var is_on_floor : bool = false
			## Player
			if body is player_body:
				weight = body.weight
			## Object
			elif body.has_meta('weight'):
				weight = body.get_meta('weight')
			
			# Force of wind's pushing
			var lessen_force : int = 1
			if is_on_floor:
				lessen_force = 3
			
			if body is player_body:
				body.velocity.x += DIRECTION.x / (weight * lessen_force)
				body.velocity.y += DIRECTION.y / (weight * lessen_force)
			elif body is RigidBody2D:
				body.linear_velocity.x += DIRECTION.x / (weight * lessen_force)
				body.linear_velocity.y += DIRECTION.y / (weight * lessen_force)
