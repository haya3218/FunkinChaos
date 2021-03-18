package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import lime.utils.Assets;
// visual studio code gets pissy when you don't use conditionals
#if sys
import sys.io.File;
#end
import haxe.Json;

using StringTools;
typedef TOption = {
	var name:String;
	var value:Bool;
}
class SaveDataState extends MusicBeatState
{
    // THERES LOTS OF LEFTOVER CODE FROM MODDING PLUS, BUT IT WORKS NONETHELESS.
	var saves:FlxTypedSpriteGroup<SaveFile>;
	var options:FlxTypedSpriteGroup<Alphabet>;
	// this will need to be initialized in title state!!!
	public static var optionList:Array<TOption>;
	var scoreText:FlxText;
	var fpText:FlxText;
	var diffText:FlxText;
	var curSelected:Int = 0;
	var inOptionsMenu:Bool = false;
	var optionsSelected:Int = 0;
	var checkmarks:FlxTypedSpriteGroup<FlxSprite>;
	var preferredSave:Int = 0;
	var scoreBG:FlxSprite;
	override function create()
	{
        FlxG.sound.playMusic('assets/sounds/HGGJ' + TitleState.soundExt);

		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		optionList = [
						{name: "Limit FPS", value: false}, 
						{name: "Notestrum Test", value: false},
						{name: "No LS Cutscenes", value: false},
						{name: "Less LS Effect", value: false},
						{name: "Bold Intro Alphabet", value: true},
						{name: "Cinematic Mode", value: true}
						// {name: "Sample Option", value: false, int: 0}
					];
		// we use a var because if we don't it will read the file each time
		// although it isn't as laggy thanks to assets
		var curOptions = OptionsHandler.options;
		preferredSave = curOptions.preferredSave;
		optionList[0].value = curOptions.fpsLimit;
		optionList[1].value = curOptions.p2noteStrums;
		optionList[2].value = curOptions.momentCutscene;
		optionList[3].value = curOptions.momentEffect;
		optionList[4].value = curOptions.boldText;
		optionList[5].value = curOptions.cinematicMode;
		// optionList[6].int = curOptions.sampleOption;
		menuBG.color = 0xFF7194fc;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		trace("before");
		trace("x3");
		checkmarks = new FlxTypedSpriteGroup<FlxSprite>();
		options = new FlxTypedSpriteGroup<Alphabet>();
		trace("hmmm");
		for (j in 0...optionList.length) 
		{
			trace("l53");
			var swagOption = new Alphabet(0,0,optionList[j].name,true,false);
			swagOption.isOptionItem = true;
			swagOption.targetY = j;
			swagOption.x += 50;
			trace("l57");
			var coolCheckmark = new FlxSprite().loadGraphic('assets/images/checkmark.png');

			coolCheckmark.visible = optionList[j].value;
			checkmarks.add(coolCheckmark);
			swagOption.add(coolCheckmark);
			options.add(swagOption);
		}
		scoreText = new FlxText(FlxG.width * 0.77, 5, 0, "", 64);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		fpText = new FlxText(scoreText.x + 120, 5, 0, "", 64);
		// scoreText.autoSize = false;
		fpText.setFormat("assets/fonts/vcr.ttf", 64, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(menuBG);
		add(options);
		
		trace("hewwo");
		options.y = 10;
		super.create();
	}

	override function update(elapsed:Float) 
	{
		super.update(elapsed);
		if (controls.BACK) 
		{
            FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
            FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, 70);
			saveOptions();
			FlxG.switchState(new OptionsMenu());
		}
		if (controls.UP_P)
		{
			changeSelection(-1);
		}
		if (controls.DOWN_P)
		{
			changeSelection(1);
		}
		if (controls.ACCEPT) 
		{
			checkmarks.members[optionsSelected].visible = !checkmarks.members[optionsSelected].visible;
			optionList[optionsSelected].value = checkmarks.members[optionsSelected].visible;
			saveOptions();
			FlxG.sound.play('assets/sounds/confirmMenu.ogg');
		}

	}
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		optionsSelected += change;

		if (optionsSelected < 0)
			optionsSelected = options.members.length - 1;
		if (optionsSelected >= options.members.length)
			optionsSelected = 0;

		var bullShit:Int = 0;

		for (item in options.members)
		{
			item.targetY = bullShit - optionsSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
	function saveOptions() {
		OptionsHandler.options = 
		{
			"cinematicMode": optionList[5].value,
			"boldText": optionList[4].value,
			"momentEffect": optionList[3].value,
			"momentCutscene": optionList[2].value,
			"p2noteStrums": optionList[1].value,
			"fpsLimit": optionList[0].value,
			// just use whatever it is 
			"preferredSave": preferredSave
		};
        if (OptionsHandler.options.fpsLimit)
        {
            MusicBeatState.funkyFramerate = 60;
            FlxG.drawFramerate = 60;
        }
        else if (!OptionsHandler.options.fpsLimit)
        {
            MusicBeatState.funkyFramerate = 160;
            FlxG.drawFramerate = 160;
        }
	}
}