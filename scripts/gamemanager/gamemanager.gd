extends Node

enum GAMESTATE { MAIN_MENU = 0, FIGHTING = 1, PAUSE = 2, DEATH = 3, LEVEL_UP = 4, SHOP = 5 }

const MAIN_MENU = 0
const FIGHTING = 1
const PAUSE = 2
const DEATH = 3
const LEVEL_UP = 4
const SHOP = 5

static var active_game_state: GAMESTATE = MAIN_MENU
