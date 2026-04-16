extends StaticBody2D

class_name ladder

@onready var LADDER_CLIMB_CHECK = $Area2D

func _physics_process(_delta):
	for i in LADDER_CLIMB_CHECK.get_overlapping_bodies():
		if i is CharacterBody2D:
			var character = i.get_node('.')
			if Input.is_action_pressed('UP'):
				character.ANIMATE.play('climb flat')
				character.velocity.y = -50
	
