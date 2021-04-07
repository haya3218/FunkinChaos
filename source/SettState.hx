package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.system.ui.FlxSoundTray;

using StringTools;

class SettState extends MusicBeatState
{
	var menuShit:Array<String> = ['LOWER FRAMERATE', 'TOGGLE FULLSCREEN'];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var thingText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpMenuShit:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic('assetss/images/menuBGBlue.png');
		bg.color = 0xfa6746;
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuShit.length)
		{
			var menuText:Alphabet = new Alphabet(0, (70 * i) + 30, menuShit[i], true, false);
			menuText.isMenuItem = true;
			menuText.targetY = i;
			grpMenuShit.add(menuText);
		}

		thingText = new FlxText(FlxG.width * 0.905, 5, 0, "", 32);
		// scoreText.autoSize = false;
		thingText.setFormat("assetss/fonts/truvcr.ttf", 64, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var thingBG:FlxSprite = new FlxSprite(thingText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.405), 66, 0xFF000000);
		thingBG.alpha = 0.6;
		add(thingBG);

		add(thingText);

		thingText.text = 'OFF';
		changeSelection();

		// FlxG.sound.playMusic('assetss/music/title' + TitleState.soundExt, 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new OptionsState());
		}

		if (accepted)
		{
			// to alarm an error lolz
			FlxG.sound.play('assetss/sounds/beep.ogg');

			var daSelected:String = menuShit[curSelected];

			switch (daSelected)
			{
				case "LOWER FRAMERATE":
					if (thingText.text == "ON")
						FlxG.drawFramerate = 60;
						MusicBeatState.funkyFramerate = 60;
					if (thingText.text == "OFF")
						FlxG.drawFramerate = 160;
						MusicBeatState.funkyFramerate = 160;
				case "TOGGLE FULLSCREEN":
					if (thingText.text == "ON")
						FlxG.fullscreen = true;
					if (thingText.text == "OFF")
						FlxG.fullscreen = false;
				// WONT WORK BECAUSE I SUCK!
				/*
				case "TOGGLE SCORE":
					if (MusicBeatState.scoreDisplay == 1)
					{
						MusicBeatState.scoreDisplay == 0;
					}
					else
					{
						MusicBeatState.scoreDisplay == 1;
					}
				case "TOGGLE COMBOS":
					if (MusicBeatState.comboDisplay == 1)
					{
						MusicBeatState.comboDisplay == 0;
					}
					else
					{
						MusicBeatState.comboDisplay == 1;
					}
				*/
			}
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
	
		if (curDifficulty < 0)
			curDifficulty = 1;
		if (curDifficulty > 1)
			curDifficulty = 0;
	
		switch (curDifficulty)
		{
			case 0:
				thingText.text = "ON";
			case 1:
				thingText.text = 'OFF';
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assetss/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = menuShit.length - 1;
		if (curSelected >= menuShit.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
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
