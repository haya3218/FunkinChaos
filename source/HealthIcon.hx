package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
		/**
	 * Used for FreeplayState, BSidesState, and CustomSongState! If you use it elsewhere, prob gonna annoying
	 */
	 public var sprTracker:FlxSprite;
<<<<<<< Updated upstream
=======
	public var char:String;
>>>>>>> Stashed changes

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic('assets/images/iconGrid.png', true, 150, 150);
		this.char = char;

		// reworked the entire icon system because default shit so it doesnt crash lmfao
		antialiasing = true;
		switch (char) {
			case 'bf':
				animation.add('icon', [0, 1], 0, false, isPlayer);
			case 'bf-car':
				animation.add('icon', [0, 1], 0, false, isPlayer);
			case 'bf-christmas':
				animation.add('icon', [0, 1], 0, false, isPlayer);
			case 'spooky':
				animation.add('icon', [2, 3], 0, false, isPlayer);
			case 'pico':
				animation.add('icon', [4, 5], 0, false, isPlayer);
			case 'mom':
				animation.add('icon', [6, 7], 0, false, isPlayer);
			case 'mom-car':
				animation.add('icon', [6, 7], 0, false, isPlayer);
			case 'tankman':
				animation.add('icon', [8, 9], 0, false, isPlayer);
			case 'face':
				animation.add('icon', [10, 11], 0, false, isPlayer);
			case 'dad':
				animation.add('icon', [12, 13], 0, false, isPlayer);
			case 'bf-old':
				animation.add('icon', [14, 15], 0, false, isPlayer);
			case 'gf':
				animation.add('icon', [16, 16], 0, false, isPlayer);
			case 'parents-christmas':
				animation.add('icon', [17,17], 0, false, isPlayer);
			case 'monster':
				animation.add('icon', [19, 20], 0, false, isPlayer);
			case 'monster-christmas':
				animation.add('icon', [19, 20], 0, false, isPlayer);
			case 'senpai':
				animation.add('icon', [22, 22], 0, false, isPlayer);
			case 'senpai-angry':
				animation.add('icon', [22, 22], 0, false, isPlayer);
			case 'spirit':
				animation.add('icon', [23, 23], 0, false, isPlayer);
			case 'bf-pixel':
				animation.add('icon', [21, 21], 0, false, isPlayer);
			case 'diva':
				animation.add('icon', [35, 36], 0, false, isPlayer);
			case 'gaming':
				animation.add('icon', [35, 36], 0, false, isPlayer);
			case 'gaming-car':
				animation.add('icon', [35, 36], 0, false, isPlayer);
			case 'gaming-christmaslights':
				animation.add('icon', [35, 36], 0, false, isPlayer);
			case 'bf-boxman':
				animation.add('icon', [24, 25], 0, false, isPlayer);
			case 'bf-yakuza':
				animation.add('icon', [26, 27], 0, false, isPlayer);
			case 'smile':
				animation.add('icon', [28, 29], 0, false, isPlayer);
			case 'lucky':
				animation.add('icon', [30], 0, false, isPlayer);
			case 'mom-glitch':
				animation.add('icon', [31], 0, false, isPlayer);	
			case 'bf-cursed':
				animation.add('icon', [32, 33], 0, false, isPlayer);	
			case 'miku':
				animation.add('icon', [34, 46], 0, false, isPlayer);
			case 'bf-pain':
				animation.add('icon', [37, 38], 0, false, isPlayer);
			case 'bishop-gaming':
				animation.add('icon', [40], 0, false, isPlayer);
			case 'bf-cursed-wh':
				animation.add('icon', [41], 0, false, isPlayer);
			case 'kiryu':
				animation.add('icon', [42, 43], 0, false, isPlayer);
			case 'luci-moment':
				animation.add('icon', [44, 45], 0, false, isPlayer);
			default:
				animation.add('icon', [0, 1], 0, false, isPlayer);
		}
		animation.play('icon');
		scrollFactor.set();
	}
	
	override function update(elapsed:Float)
		{
			super.update(elapsed);
	
			if (sprTracker != null)
				setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
		}
}
