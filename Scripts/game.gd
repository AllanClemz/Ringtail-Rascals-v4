extends Node2D

# Game
@onready var GAME = $"."
# Player
@onready var PLAYER = $"Player Body"
# Player Camera
@onready var CAMERA : Camera2D = $"Player Body/Camera2D"

# All rooms
@onready var ROOM_BANK = get_tree().get_nodes_in_group("Room Group")
# All rooms' areas
var ROOM_AREA_BANK : Array
# All rooms' texture grounds
var TEXTURE_GROUNDS_BANK : Array


# --- ON READY ---
func _ready():
	# Get rooms' detection areas
	for i : Node2D in ROOM_BANK:
		var room_area : Area2D = i.get_node("Room Area")
		ROOM_AREA_BANK.append(room_area)
	
	# Get rooms' texture grounds
	for i in ROOM_BANK:
		var texture_grounds = i.get_node("Texture Grounds")
		TEXTURE_GROUNDS_BANK.append(texture_grounds)

# --- LOOP ---
func _process(_delta):
	detect()



func detect():
	for i : Area2D in ROOM_AREA_BANK:
		var ROOM = i.get_parent()
		for x in i.get_overlapping_bodies():
				if x == PLAYER:
					camera(i)
					roomOverlay(ROOM)
					

func camera(area):
	var area_collision : CollisionShape2D = area.get_child(0)
	
	var room_origin = area_collision.global_position
	var room_size = area_collision.shape.size
	
	# Limits
	CAMERA.limit_left = room_origin.x - room_size.x/2
	CAMERA.limit_top = room_origin.y - room_size.y/2
	CAMERA.limit_right = room_origin.x + room_size.x/2
	CAMERA.limit_bottom = room_origin.y + room_size.y/2
	
	# Zoom
	var VIEWPORT_RECT = get_viewport_rect()
	var zoom_aspect = VIEWPORT_RECT.size.y / room_size.y
	CAMERA.zoom = Vector2(zoom_aspect,zoom_aspect)

func roomOverlay(room): 
	var current_texture_grounds : Node2D = room.get_node("Texture Grounds")
	for i : Node2D in TEXTURE_GROUNDS_BANK:
		if i == current_texture_grounds:
			i.visible = true
		else:
			i.visible = false
