package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var ver = "v" + Application.current.meta.get('version');
		var verC = "v" + RealMainMenuState.chaosVer;
		var txt:FlxText = new FlxText(0, 0, FlxG.width,"WARNING!\nFNF CHAOS IS NOT MEANT FOR LOWER END PCS!\nIF YOU CAME HERE WITH A LOWER END PC THEN YOU WILL SUFFER\nUNDERSTAND?\n \nCurrent version is: " + ver + "\nCurrent chaos nightly version is: " + verC + "\nPRESS ANY KEY TO CONTINUE", 32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK || controls.ACCEPT)
		{
			leftState = true;
			FlxG.switchState(new RealMainMenuState());
		}
		super.update(elapsed);
	}
}
