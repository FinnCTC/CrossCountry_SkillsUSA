extends CharacterBody3D

@export var mouse_sensitivity : float
@export var movement_speed: int

var twist_input := 0.0
var pitch_input := 0.0

const gravity := 9.8

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	
	#MOVEMENT
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_foward", "move_back")
	
	var forward = %Camera3D.global_basis.z
	var right = %Camera3D.global_basis.x
	
	var movement_vector = (forward * input.z) + (right * input.x)
	
	velocity = movement_vector * movement_speed
	
	if not is_on_floor():
		velocity.y -= gravity
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	#CAMERA
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
		deg_to_rad(-30), 
		deg_to_rad(30)
	)
	twist_input = 0.0
	pitch_input = 0.0
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
