extends RigidBody2D

class_name trash_heap

#@onready var TRASH_AREA : Area2D = $"Trash Area"


func _on_trash_area_body_entered(body: Node2D):
	if body is player_body:
		body.formSwap()
