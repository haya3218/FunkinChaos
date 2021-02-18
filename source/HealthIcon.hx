package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic('assets/images/iconGrid.png', true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('bf-icon', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-car', [16], 0, false, isPlayer);
		animation.add('gf-christmas', [16], 0, false, isPlayer);
		animation.add('gf-pixel', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('diva', [35, 36], 0, false, isPlayer);
		animation.add('gaming', [39], 0, false, isPlayer);
		animation.add('gaming-car', [39], 0, false, isPlayer);
		animation.add('gaming-christmaslights', [39], 0, false, isPlayer);
		animation.add('bf-boxman', [24, 25], 0, false, isPlayer);
		animation.add('bf-yakuza', [26, 27], 0, false, isPlayer);
		animation.add('smile', [28, 29], 0, false, isPlayer);
		animation.add('default', [0, 1], 0, false, isPlayer);
		animation.add('lucky', [30], 0, false, isPlayer);
		animation.add('mom-glitch', [31], 0, false, isPlayer);
		animation.add('bf-cursed', [32, 33], 0, false, isPlayer);
		animation.add('miku', [34], 0, false, isPlayer);
		animation.add('bf-pain', [37, 38], 0, false, isPlayer);
		animation.add('bishop-gaming', [40], 0, false, isPlayer);
		animation.add('bf-cursed-wh', [41], 0, false, isPlayer);
		animation.play(char);
		scrollFactor.set();
	}
}
