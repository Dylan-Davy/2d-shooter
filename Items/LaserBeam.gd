extends RayCast2D

export var cast_speed := 7000.0
export var max_length := 1400
export var growth_time := 0.1

onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var beam_particles := $BeamParticles2D
onready var fill := $FillLine2D
onready var tween := $Tween
onready var line_width: float = fill.width

var is_casting
var weapon

func _ready():
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO

func _physics_process(delta):
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	cast_beam(delta)

func set_is_casting(cast, weapon):
	is_casting = cast
	self.weapon = weapon
	
	if is_casting:
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
	else:
		collision_particles.emitting = false
		disappear()

	set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting

func cast_beam(delta):
	var cast_point = cast_to

	# Required, the raycast's collisions update one frame after moving otherwise, making the laser
	# overshoot the collision point.
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.process_material.direction = Vector3(
			get_collision_normal().x, get_collision_normal().y, 0)
	
		if get_collider().is_in_group("Enemies"):
			get_collider().hurt(get_parent().get_parent(), weapon.damage * delta, weapon.damage_type)
			
	collision_particles.emitting = is_colliding()

	fill.points[1] = cast_point
	collision_particles.position = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func appear():
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()

func disappear():
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()
