extends CharacterBody3D

@export var mouse_sensitivity : float
@export var movement_speed: int
@export var max_movement_speed: int
@export var acceleration: float
@export var gravity: float

enum {IDLE, RUN, GLIDE}
var curAnim = IDLE



@onready var anim_tree = $KEISHI_WOMats/AnimationTree



var twist_input := 0.0
var pitch_input := 0.0

const FRAME_TIME :=  0.17

var time_accumulator := 0.0
var last_animation := ""
var animation_position := 0.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func handle_animations(curAnim):
	match curAnim:
		IDLE:
			anim_tree.set("parameters/Transition/transition_request", "Idle")
		RUN:
			anim_tree.set("parameters/Transition/transition_request", "Run")
		GLIDE:
			glide()

func jump():
	anim_tree.set("parameters/Jump/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
func glide():
	anim_tree.set("parameters/Glide_Transition/transition_request", "Glide_S")
	anim_tree.set("parameters/Glide_Transition/transition_request", "Glide")
	anim_tree.set("parameters/Transition/transition_request", "Glide")
	
func _process(delta: float) -> void:
	
	#MOVEMENT
	
	#Horizontal movement
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_foward", "move_back")
	
	var forward = %Camera3D.global_basis.z
	var right = %Camera3D.global_basis.x
	
	var movement_vector = (forward * input.z) + (right * input.x)
	
	#handles speeding up and slowing down in movement
	if input:
		velocity.x = move_toward(velocity.x,movement_vector.x * max_movement_speed, acceleration)
		velocity.z = move_toward(velocity.z, movement_vector.z * max_movement_speed, acceleration)
		if is_on_floor():
			handle_animations(RUN)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
		velocity.z = move_toward(velocity.z, 0, acceleration)
		if is_on_floor():
			handle_animations(IDLE)
	
	#Jump
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = 30
		jump()
	
	#Glide ability
	
	var glide_speed = -2
	
	if Input.is_action_pressed("move_jump") and not is_on_floor():
		if velocity.y < glide_speed:
			velocity.y = glide_speed
			handle_animations(GLIDE)
	
	#gravity
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
