extends Node

const AppID = "480"

func _init() -> void:
	connect_steam()

func connect_steam():
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)

func _ready() -> void:
	Steam.steamInit()
	var IsRunning = Steam.isSteamRunning()
	
	if !IsRunning:
		print("ERROR: Steam is not running.")
		return
