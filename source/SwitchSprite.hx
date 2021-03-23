package;

import flixel.FlxSprite;

class SwitchSprite extends FlxSprite
{
		/**
	 * Used for SaveDataState! If you use it elsewhere, prob gonna annoying
	 */
	 public var sprTracker:FlxSprite;

	public function new(whichSprite:String)
	{
		super();
		loadGraphic('assets/images/' + whichSprite + '.png');
		antialiasing = true;
		scale.set(1.1, 1.1);
		updateHitbox();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	
		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
