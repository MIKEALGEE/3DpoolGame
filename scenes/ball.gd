extends RigidBody3D
class_name Ball

const BALL_RADIUS := 0.027
const BALL_DIAMETER := BALL_RADIUS * 2
@export var _texture: Texture2D

static var num_balls_moving: int = 0

var _ball_num := 0
var ball_type: Enums.BallType = Enums.BallType.CUE_BALL


func _ready():
	GameEvents.ball_potted.connect(_on_ball_potted)
	if not self.sleeping:
		Ball.num_balls_moving += 1
	
	
	_apply_new_material()
	
	#$BallMesh.get_active_material(0).albedo_texture = _texture

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if not self.sleeping:
		self.linear_velocity.y = min(Ball.BALL_DIAMETER,self.linear_velocity.y)

func setup_ball(ball_num: int,ball_x:float,ball_z:float):
	_ball_num = ball_num
	
	if ball_num == 8:
		self.ball_type = Enums.BallType.EIGHT_BALL
	elif ball_num == 0:
		self.ball_type = Enums.BallType.CUE_BALL
	elif ball_num <8: 
		self.ball_type = Enums.BallType.SOLIDS
	else:
		self.ball_type = Enums.BallType.STRIPES
		
	self.position.x = ball_x
	self.position.z = ball_z
	_texture = load("res://assets/textures/" + str(ball_num) + ".jpg")
	_apply_new_material()


func is_object_ball() -> bool:
	return (self.ball_type == Enums.BallType.SOLIDS
			or self.ball_type == Enums.BallType.STRIPES)

func set_freeze_state(new_freeze_state:bool):
	self.sleeping = new_freeze_state
	self.sleeping_state_changed.emit()
	self.freeze = new_freeze_state

func _apply_new_material():
	var new_material = StandardMaterial3D.new()
	new_material.albedo_texture = _texture
	$BallMesh.material_override = new_material


func _on_sleeping_state_changed() -> void:
	if self.sleeping:
		Ball.num_balls_moving -= 1
	else:
		Ball.num_balls_moving += 1
	
	if Ball.num_balls_moving == 0:

		GameEvents.all_balls_stopped.emit()
		

	#print("Number of balls moving: " ,num_balls_moving)

func _on_ball_potted(ball, pocket):
	if (ball == self):
		self.set_freeze_state(true)
		self.position = Vector3(0,-0.5,0)

