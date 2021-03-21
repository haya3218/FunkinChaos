package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var week:FlxSprite;
	public var flashingInt:Int = 0;
	public var flashingIntRed:Int = 0;

	public function new(x:Float, y:Float, weekNum:Int = 0)
	{
		super(x, y);
		// TUTORIAL IS WEEK 0
		week = new FlxSprite().loadGraphic('assets/images/storymenu/week' + weekNum + '.png');
		add(week);
	}

	private var isFlashing:Bool = false;
	private var isFlashingRed:Bool = false;

	public function startFlashing():Void
	{
		isFlashing = true;
	}

	public function startFlashingRed():Void
	{
		isFlashingRed = true;
	}

	// if it runs at 60fps, fake framerate will be 6
	// if it runs at 144 fps, fake framerate will be like 14, and will update the graphic every 0.016666 * 3 seconds still???
	// so it runs basically every so many seconds, not dependant on framerate??
	// I'm still learning how math works thanks whoever is reading this lol
	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (PlayState.hasPlayedOnce)
		{
			y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17 * (60.0 / MusicBeatState.funkyFramerate));
		}
		else if (!PlayState.hasPlayedOnce)
		{
			y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17);
		}

		if (isFlashing)
			flashingInt += 1;

		if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2))
			week.color = 0xFF33ffff;
		else
			week.color = FlxColor.WHITE;

		if (isFlashingRed)
			flashingIntRed += 1;

		if (flashingIntRed % fakeFramerate >= Math.floor(fakeFramerate / 2))
			week.color = 0xFF0000;
		else
			week.color = FlxColor.WHITE;
	}
}
