extends Node

enum GAMESTATE { ACTIVE = 1, PAUSED = 2, DIED = 3, WAVE_END = 4 }

const ACTIVE = 1
const PAUSED = 2
const DIED = 3
const WAVE_END = 4

static var active_game_state: GAMESTATE = ACTIVE

signal on_active_game_state_changed(state: GAMESTATE)

func set_active_game(state: GAMESTATE):
	active_game_state = state
	on_active_game_state_changed.emit(state)
