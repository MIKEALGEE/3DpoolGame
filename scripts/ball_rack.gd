extends Node3D
@export var _ball_tscn : PackedScene


func _ready(): 
	self.position = BilliardTable.FOOT_SPOT
	
	_rack_balls()

func _rack_balls():
	var ball_nums := range(1,16)
	ball_nums.shuffle()
	
	var rand_8_index := ball_nums.find(8)
	var rand_num_at_index_4 = ball_nums[4] as int
	ball_nums[4] = 8
	ball_nums[rand_8_index] = rand_num_at_index_4
	
	const DIAMETER = Ball.BALL_DIAMETER
	const RADIUS = Ball.BALL_RADIUS
	var ball_i = 0
	
	for i in 5:
		for j in i+1:
			var new_ball:Ball = _ball_tscn.instantiate() as Ball
			var ball_x := i * DIAMETER * 0.9
			var ball_z := (i * RADIUS) - (j * DIAMETER)
			new_ball.setup_ball(ball_nums[ball_i],ball_x,ball_z)
			
			self.add_child(new_ball)
			new_ball.rotate_x(30)
			new_ball.rotate_y(30)

			ball_i += 1
