package;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class NewGameState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var sinMod:Float = 0;
	var txt:FlxText = new FlxText(0, 360, FlxG.width,
		"WARNING:\nFNF: Chaos may potentially trigger seizures for people with photosensitive epilepsy. Viewer discretion is advised.\n\n"
		+ "FNF: Chaos is a non-profit modification, aimed for entertainment purposes, and wasn't meant to be an attack on Ninjamuffin99"
		+ " and/or any other modmakers out there. I was not aiming for replacing what Friday Night Funkin' was, won't be aiming for that and never"
		+ " will be aiming for that. It was made for fun and from the love for the game itself. All of the comparisons between this and other mods are purely coincidental, unless stated otherwise.\n\n"
		+ "Now with that out of the way, I hope you'll enjoy this FNF mod.\nFunk all the way.\nPress ENTER to proceed",
		32);

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		add(txt);
	}

	override function update(elapsed:Float)
	{
		sinMod += 0.007;
		txt.y = Math.sin(sinMod)*60+100;

		if (controls.ACCEPT)
		{
            TitleState.shittyPieceofShitScreenDetectorCosImDumbLmao = true;
			FlxG.switchState(new TitleState());
		}
		super.update(elapsed);
	}
}