package;

import Sys.sleep;
import discord_rpc.DiscordRpc;
import flixel.FlxG;

using StringTools;

class DiscordClient
{
	public function new(clientID:String)
	{
		trace("Discord Client starting...");
		// uses standard rpc connection
		// if you ARE gonna fork this project and change the name, refer to this reddit post: 
		// https://www.reddit.com/r/discordapp/comments/a2c2un/how_to_setup_a_custom_discord_rich_presence_for/
		// you dont need to get easyRP, just replace the client id
		DiscordRpc.start({
			clientID: clientID, // <----- right there
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		// then instead of largeimagekey rename it to icon
		// you dont need a smallimagekey
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			//trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
	}

	static function onReady()
	{
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Friday Night Funkin' Chaos"
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	/*
	* uses standard rpc connection
	* if you ARE gonna fork this project and change the name, refer to this reddit post: 
	* https://www.reddit.com/r/discordapp/comments/a2c2un/how_to_setup_a_custom_discord_rich_presence_for/
	* you dont need to get easyRP, just replace the client id
	* @param	client		Client id.
	* then instead of largeimagekey rename it to icon
	* you dont need a smallimagekey
	*/
	public static function initialize(client:String)
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient(client);
		});
		trace("Discord Client initialized");
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Friday Night Funkin'",
			smallImageKey : smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
		});
	}
}