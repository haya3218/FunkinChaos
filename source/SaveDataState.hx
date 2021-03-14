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
<<<<<<< Updated upstream
=======
	var scoreText:FlxText;
	var fpText:FlxText;
	var diffText:FlxText;
>>>>>>> Stashed changes
	var curSelected:Int = 0;
	var inOptionsMenu:Bool = false;
	var optionsSelected:Int = 0;
	var checkmarks:FlxTypedSpriteGroup<FlxSprite>;
	var preferredSave:Int = 0;
<<<<<<< Updated upstream
=======
	var scoreBG:FlxSprite;
>>>>>>> Stashed changes
	override function create()
	{
        FlxG.sound.playMusic('assets/sounds/HGGJ' + TitleState.soundExt);

		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		optionList = [
						{name: "Limit FPS", value: false}, 
						{name: "Better Charselect", value: false}, 
						{name: "Notestrum Test", value: false},
<<<<<<< Updated upstream
=======
						{name: "No LS Cutscenes", value: false},
						{name: "Less LS Effect", value: false},
						{name: "Bold Intro Alphabet", value: true}
						// {name: "Sample Option", value: false, int: 0}
>>>>>>> Stashed changes
					];
		// we use a var because if we don't it will read the file each time
		// although it isn't as laggy thanks to assets
		var curOptions = OptionsHandler.options;
		preferredSave = curOptions.preferredSave;
		optionList[0].value = curOptions.fpsLimit;
		optionList[1].value = curOptions.charSelBetter;
		optionList[2].value = curOptions.p2noteStrums;
<<<<<<< Updated upstream
		saves = new FlxTypedSpriteGroup<SaveFile>();
=======
		optionList[3].value = curOptions.momentCutscene;
		optionList[4].value = curOptions.momentEffect;
		optionList[5].value = curOptions.boldText;
		// optionList[6].int = curOptions.sampleOption;
>>>>>>> Stashed changes
		menuBG.color = 0xFF7194fc;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		trace("before");
<<<<<<< Updated upstream
		for (i in 0...10) {
			var saveFile = new SaveFile(420, 0, i);

            saves.add(saveFile);
		}
=======
>>>>>>> Stashed changes
		trace("x3");
		checkmarks = new FlxTypedSpriteGroup<FlxSprite>();
		options = new FlxTypedSpriteGroup<Alphabet>();
		trace("hmmm");
<<<<<<< Updated upstream
		for (j in 0...optionList.length) {
=======
		for (j in 0...optionList.length) 
		{
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
		add(menuBG);
		add(saves);
		add(options);
		trace("hewwo");
		options.x = FlxG.width + 10;
		options.y = 10;
		swapMenus();
		super.create();
	}
	override function update(elapsed:Float) {
		super.update(elapsed);
		if (controls.BACK) {
			if (!saves.members[curSelected].beingSelected) {
				// our current save saves this
				// we are gonna have to do some shenanagins to save our preffered save
                FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
                FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, 70);
				saveOptions();
				FlxG.switchState(new OptionsMenu());
			} else {
				if (saves.members[curSelected].askingToConfirm)
					saves.members[curSelected].askToConfirm(false);
				else
					saves.members[curSelected].beSelected(false);
			}
		}
		if (inOptionsMenu || !saves.members[curSelected].askingToConfirm) {
			if (controls.UP_P)
			{
				if (inOptionsMenu||!saves.members[curSelected].beingSelected)
					changeSelection(-1);
			}
			if (controls.DOWN_P)
			{
				if (inOptionsMenu||!saves.members[curSelected].beingSelected)
					changeSelection(1);
			}
		}
		if (controls.ACCEPT) {
			if (saves.members[curSelected].beingSelected) {
				if (!saves.members[curSelected].askingToConfirm) {
					if (saves.members[curSelected].selectingLoad) {
						var saveName = "save" + curSelected;
						FlxG.save.close();
						preferredSave = curSelected;
						FlxG.save.bind(saveName, "ninjamuffin99");
						FlxG.sound.play('assets/sounds/confirmMenu.ogg');
						if (FlxG.save.data.songScores == null) {
							FlxG.save.data.songScores = ["tutorial" => 0];
						}
						Highscore.load();
					} else {
						saves.members[curSelected].askToConfirm(true);
					}

				} else {
					// this means the user confirmed!
					var oldSave = FlxG.save.name;
					var saveName = "save" + curSelected;
					FlxG.save.bind(saveName, "ninjamuffin99");
					FlxG.save.erase();
					saves.members[curSelected].askToConfirm(false);
					// sounds like someone farted into the mic. perfect for a delete sfx
					FlxG.sound.play('assets/sounds/freshIntro.ogg');
					FlxG.save.data.songScores = ["tutorial" => 0];
					FlxG.save.bind(oldSave, "ninjamuffin99");
					Highscore.load();
				}
			} else if (!inOptionsMenu) {
				FlxG.sound.play('assets/sounds/scrollMenu.ogg');
				saves.members[curSelected].beSelected(true);
			} else {
				checkmarks.members[optionsSelected].visible = !checkmarks.members[optionsSelected].visible;
				optionList[optionsSelected].value = checkmarks.members[optionsSelected].visible;

				FlxG.sound.play('assets/sounds/scrollMenu.ogg');
			}
=======
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
>>>>>>> Stashed changes
		}

	}
	function changeSelection(change:Int = 0)
	{
<<<<<<< Updated upstream
		if (!inOptionsMenu) {
			FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

			curSelected += change;

			if (curSelected < 0)
				curSelected = saves.members.length - 1;
			if (curSelected >= saves.members.length)
				curSelected = 0;


			var bullShit:Int = 0;

			for (item in saves.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;

				item.color = 0xFF828282;
				// item.setGraphicSize(Std.int(item.width * 0.8));

				if (item.targetY == 0)
				{
					item.color = 0xFFFFFFFF;
					// item.setGraphicSize(Std.int(item.width));
				}
			}
		} else {
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

	}
	function swapMenus() {
		if (inOptionsMenu) {
			FlxTween.tween(options, {x: FlxG.width + 10}, 0.2, {type: FlxTweenType.ONESHOT, ease: FlxEase.backInOut});
			FlxTween.tween(saves, {x: 0}, 0.2, {type: FlxTweenType.ONESHOT, ease: FlxEase.backInOut});
			inOptionsMenu = false;
		} else {
			FlxTween.tween(options, {x: 10}, 0.2, {type: FlxTweenType.ONESHOT, ease: FlxEase.backInOut});
			FlxTween.tween(saves, {x: -FlxG.width }, 0.2, {type: FlxTweenType.ONESHOT, ease: FlxEase.backInOut});
			inOptionsMenu = true;
		}
	}
	function saveOptions() {
		OptionsHandler.options = {
			"downScroll": optionList[3].value,
=======
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
			"boldText": optionList[5].value,
			"momentEffect": optionList[4].value,
			"momentCutscene": optionList[3].value,
>>>>>>> Stashed changes
			"p2noteStrums": optionList[2].value,
			"charSelBetter": optionList[1].value,
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