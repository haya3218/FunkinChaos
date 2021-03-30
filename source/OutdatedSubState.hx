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

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var ver = "v" + Application.current.meta.get('version');
		var txt:FlxText = new FlxText(0, 0, FlxG.width,"Haha, hey everyone, guess what? I know you wanna buy my stocks, but fuck you. I'm keeping the stocks. That's right you ugly little girl! I HATE you! And your STUPID nose! I'm taking everything from you, give me your phone! I'm taking over Victoria's Secret, I'm taking over Best Buy, the news is MINE, and everyone one else can leave. You see that planet? I'M TAKING IT, TOO! It looks like a fucking WALNUT! BAM! And it BUSTED A NUT! THEN AND THERE! menaiacle laughing Now.... DIE! lazer noises Fuck you moon, you never had the cheese I WANTED! I hope you're ready to die, it's gonna be like Evangelion. Get the FUCK out!", 32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ANY)
		{
			leftState = true;
			FlxG.switchState(new RealMainMenuState());
		}
		super.update(elapsed);
	}
}
