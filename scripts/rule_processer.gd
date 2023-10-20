extends Node

@export var _game_state: GameState

var _occurrences_during_shot:Array[Occurrence]


func _ready():
	GameEvents.all_balls_stopped.connect(_on_all_balls_stopped)
	GameEvents.ball_potted.connect(_on_ball_potted)

func _process_rules():
	#process game rules
	var cp_id = _game_state.current_player_id
	var op_id = _get_other_player_id(cp_id)
	var player_keeps_turn := false
	var foul_comitted := false
	var winning_player_id:= -1
	
	for occurrence in _occurrences_during_shot:
		
		if occurrence is PocketOccurrence:
			var ball: Ball = occurrence.ball
			
			if ball.is_object_ball():
				_check_and_set_ball_suit_for_players(ball)
			
				if ball.ball_type == _game_state.ball_suit_by_player_id[cp_id]:
					player_keeps_turn = true
					_game_state.balls_remaining_by_player_id[cp_id] -=1
				else:
					_game_state.balls_remaining_by_player_id[cp_id] -=1

			if ball.ball_type == Enums.BallType.CUE_BALL:
				foul_comitted = true
				
			
			if ball.ball_type == Enums.BallType.EIGHT_BALL:
				if _game_state.balls_remaining_by_player_id[cp_id] <= 0:
					winning_player_id = cp_id
				else:
					winning_player_id = op_id
			
			
	if player_keeps_turn == false or foul_comitted == true:
		_game_state.current_player_id = op_id
	
	if winning_player_id > -1:
		#BALL_IN_HAND IS TEMP SOLUTION FOR GAMESTATE CHANGING WHEN SOMEONE WINS
		_game_state.current_play_state = Enums.PlayState.BALL_IN_HAND
		GameEvents.game_ended.emit(winning_player_id)
	else:
		if foul_comitted:
			_game_state.current_play_state = Enums.PlayState.BALL_IN_HAND
		else:
			
			_game_state.current_play_state = Enums.PlayState.AIMING
		
		_occurrences_during_shot.clear()
		GameEvents.shot_completed.emit()

func _check_and_set_ball_suit_for_players(ball:Ball):
	var cp_id = _game_state.current_player_id
	
	if _game_state.ball_suit_by_player_id[cp_id] == Enums.BallType.TBD:
		_game_state.ball_suit_by_player_id[cp_id] = ball.ball_type
	
		var op_id = _get_other_player_id(cp_id)
		
		var suits_remaining =[Enums.BallType.SOLIDS, Enums.BallType.STRIPES]
		suits_remaining.erase(ball.ball_type)
		
		_game_state.ball_suit_by_player_id[op_id] = suits_remaining[0]

func _get_other_player_id(player_id:int) -> int:
	return int(not player_id)

func _on_ball_potted(ball:Ball,pocket: Pocket):
	var pocket_occurrence = PocketOccurrence.new()
	pocket_occurrence.ball = ball
	pocket_occurrence.pocket = pocket
	_occurrences_during_shot.append(pocket_occurrence)

## Occurrence classes
class Occurrence:
	pass

class PocketOccurrence extends Occurrence:
	var ball: Ball
	var pocket: Pocket

func _on_all_balls_stopped():
	if _game_state.current_play_state == Enums.PlayState.BALLS_IN_PLAY:
		_process_rules.call_deferred()
		#Call_deferred prevents a race condition that was causing _on_ball_potted to
		#be missed before process_rules was run, due to the all_balls_stopped signal
