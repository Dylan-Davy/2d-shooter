extends "res://Maps/TemplateLevel.gd"

var spawn_point
var spawns
var room_1 = "closed"
var room_2 = "closed"
var room_3 = "closed"
var room_4 = "closed"
var room_5 = "closed"
var room_6 = "closed"
var room_7 = "closed"
var room_8 = "closed"
var room_9 = "closed"

func _ready():
	spawns = $TemplateSpawner/LockedSpawnPoints
	
func door_opened(door):
	if door == "Door1":
		$Navigation2D/Tilemaps/Navigation.set_cell(17,-3,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(18,-3,0)
		
		if room_1 == "closed":
			room1()
			room_1 = "open"
			
	elif door == "Door2":
		$Navigation2D/Tilemaps/Navigation.set_cell(-2,-3,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(-2,-2,0)
		
		if room_9 == "closed":
			room9()
			room_9 = "open"
			
	elif door == "Door3":
		$Navigation2D/Tilemaps/Navigation.set_cell(-18,-5,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(-18,-6,0)
		
		if room_8 == "closed":
			room8()
			room_8 = "open"
			
		if room_9 == "closed":
			room9()
			room_9 = "open"
			
	elif door == "Door4":
		$Navigation2D/Tilemaps/Navigation.set_cell(-30,-15,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(-29,-15,0)
		
		if room_8 == "closed":
			room8()
			room_8 = "open"
			
		if room_6 == "closed":
			room6()
			room_6 = "open"
			
	elif door == "Door5":
		$Navigation2D/Tilemaps/Navigation.set_cell(-37,-22,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(-37,-23,0)
		
		if room_7 == "closed":
			room7()
			room_7 = "open"
			
	elif door == "Door6":
		$Navigation2D/Tilemaps/Navigation.set_cell(-13,-26,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(-13,-27,0)
		
		if room_5 == "closed":
			room5()
			room_5 = "open"
			
		if room_6 == "closed":
			room6()
			room_6 = "open"
			
	elif door == "Door7":
		$Navigation2D/Tilemaps/Navigation.set_cell(24,0,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(25,0,0)
		
		if room_2 == "closed":
			room2()
			room_2 = "open"
			
	elif door == "Door8":
		$Navigation2D/Tilemaps/Navigation.set_cell(30,-5,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(30,-6,0)
		
		if room_1 == "closed":
			room1()
			room_1 = "open"
			
		if room_3 == "closed":
			room3()
			room_3 = "open"
			
	elif door == "Door9":
		$Navigation2D/Tilemaps/Navigation.set_cell(46,-13,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(47,-13,0)
		
		if room_3 == "closed":
			room3()
			room_3 = "open"
			
		if room_4 == "closed":
			room4()
			room_4 = "open"
			
	elif door == "Door10":
		$Navigation2D/Tilemaps/Navigation.set_cell(33,-26,0)
		$Navigation2D/Tilemaps/Navigation.set_cell(33,-27,0)
		
		if room_4 == "closed":
			room4()
			room_4 = "open"
			
		if room_5 == "closed":
			room5()
			room_5 = "open"

	$TemplateSpawner.possible_spawns = $TemplateSpawner/SpawnPoints.get_children()

func room1():
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn1").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn1").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn2").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn2").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
func room2():
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn3").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn3").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
func room3():
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn4").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn4").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn5").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn5").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
func room4():
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn6").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn6").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn7").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn7").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn8").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn8").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
func room5():
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn9").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn9").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn10").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn10").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn11").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn11").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn12").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn12").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn13").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn13").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
func room6():
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn14").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn14").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn15").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn15").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
func room7():
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn16").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn16").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
func room8():
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn17").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn17").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn18").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn18").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn19").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn19").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
func room9():
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn20").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn20").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
	
	spawn_point = Position2D.new()
	spawn_point.position.x = spawns.get_node("LockedSpawn21").position.x
	spawn_point.position.y = spawns.get_node("LockedSpawn21").position.y
	$TemplateSpawner/SpawnPoints.add_child(spawn_point)
