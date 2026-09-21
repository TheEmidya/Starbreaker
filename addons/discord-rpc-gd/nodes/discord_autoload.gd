## This is a GDscript Node wich gets automatically added as Autoload while installing the addon.
## 
## It can run in the background to comunicate with Discord.
## You don't need to use it. If you remove it make sure to run [code]DiscordRPC.run_callbacks()[/code] in a [code]_process[/code] function.
##
## @tutorial: https://github.com/vaporvee/discord-rpc-godot/wiki

extends Node

func _ready():
	DiscordRPC.app_id = 1489331019223138334 # Application ID
	DiscordRPC.details = "TESTING - " + str(OS.get_version()) + str(Engine.get_architecture_name()) + " version_" + str(ProjectSettings.get_setting("application/config/version"))
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
	# DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00:00 remaining"

	DiscordRPC.refresh() # Always refresh after changing the values!

func  _process(_delta) -> void:
	DiscordRPC.run_callbacks()
