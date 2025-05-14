extends Node

enum GAMESTATE { MAIN_MENU = 0, FIGHTING = 1, PAUSE = 2, DEATH = 3, ROUND_END = 4 }

const MAIN_MENU = 0
const FIGHTING = 1
const PAUSE = 2
const DEATH = 3
const ROUND_END = 4

static var active_game_state: GAMESTATE = FIGHTING
