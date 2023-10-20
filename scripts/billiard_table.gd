extends Node3D
class_name BilliardTable
const HEAD_SPOT = Vector3(-0.535,Ball.BALL_RADIUS,0)
const FOOT_SPOT = Vector3(0.535,Ball.BALL_RADIUS,0)
#static var HEAD_SPOT
#@onready var head_spot_cheat = (func():
 #BilliardTable.HEAD_SPOT = Vector3($Headspot.position.x,0.03,0)).call()
