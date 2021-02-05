package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import Song.SwagSong;

using StringTools;

class ModifierState extends MusicBeatState
{
	var menuItems:Array<String> = ['Deathless', 'Invisible Notes', 'Invisible Arrows', 'Go for a Perfect', 'NO MODIFIERS'];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpModifier:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	public static var songName:SwagSong;
	public static var difficulty:Int = 0;
	public static var curModifier:Int = 0;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBGBlue.png');
		add(bg);

		grpModifier = new FlxTypedGroup<Alphabet>();
		add(grpModifier);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 50, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpModifier.add(songText);
			songText.screenCenter(X);
			songText.x += 160;
		}

		changeSelection();

		// FlxG.sound.playMusic('assets/music/title' + TitleState.soundExt, 0);
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
		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
			changeSelection(-1);
		}
		if (downP)
		{
			FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Deathless":
					curModifier == 1;
				case "Invisible Notes":
					curModifier == 2;
				case "Invisible Arrows":
					curModifier == 3;
				case "Invisible Notes Arrows":
					curModifier == 4;
				case "Go for a Perfect":
					curModifier == 5;
				case "NO MODIFIERS":
					PlayState.SONG = songName;
					PlayState.hasModifier = curModifier;
					PlayState.storyDifficulty = difficulty;
					new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							FlxG.switchState(new PlayState());
						});
					if (FlxG.sound.music != null)
						FlxG.sound.music.stop();
			}
		}
	}

	function changeSelection(change:Int = 0):Void
		{
			curSelected += change;
	
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
			if (curSelected >= menuItems.length)
				curSelected = 0;
	
			var bullShit:Int = 0;
	
			for (item in grpModifier.members)
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
