extends Node2D

# Player
@onready var PLAYER = $"Player Body" 

var ROOM_BANK : Array
var CAMERA_BANK : Array
func _ready():
	var SCENE = $"Apartment Level"
	for i in SCENE.get_children():
		if i.is_in_group('Room Group'):
			ROOM_BANK.append(i)
	for i in ROOM_BANK:
		for x in i.get_children():
			if x is Camera2D:
				CAMERA_BANK.append(x)
	print(ROOM_BANK)
	print(CAMERA_BANK)
	
	for camera in Camera



func _process(_delta):
	for camera in CAMERA_BANK:
		pass
	
