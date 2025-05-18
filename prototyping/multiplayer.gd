extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner

func _ready() -> void:
	multiplayer_spawner.spawn_function = _spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	_open_lobby_list()

func _spawn_level(data):
	var level = (load(data) as PackedScene).instantiate()
	return level

func _on_host_pressed() -> void:
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	multiplayer_spawner.spawn("res://prototyping/prototype_level.tscn")
	$Host.hide()
	$LobbyContainer/Lobbies.hide()
	
func _join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	$Host.hide()
	$LobbyContainer/Lobbies.hide()
	
func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName() + "'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)

func _open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
	
func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var memb_count = Steam.getNumLobbyMembers(lobby)
		
		var button = Button.new()
		button.set_text(str(lobby_name + "| Player count: ", memb_count))
		button.set_size(Vector2(100, 5))
		button.connect("pressed", Callable(self, "_join_lobby").bind(lobby))
		
		$LobbyContainer/Lobbies.add_child(button)


func _on_refresh_pressed() -> void:
	if $LobbyContainer/Lobbies.get_child_count() > 0:
		for n in $LobbyContainer/Lobbies.get_children():
			n.queue_free()
