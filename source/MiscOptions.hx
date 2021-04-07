package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class MiscOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assetss/images/menuDesat.png');
		controlsStrings = CoolUtil.coolStringFile(
			"\nSong Position " + (!FlxG.save.data.songPosition ? "off" : "on") +
			"\nEtterna Mode " + (!FlxG.save.data.etternaMode ? "off" : "on") +
			"\nITG SCORE " + (!FlxG.save.data.itgPopupScore ? "off" : "on") +
			"\nExperimental Mines " + (!FlxG.save.data.fireNoteSupremacy ? "off" : "on"));
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}


		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		// add(versionShit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new OptionsMenu());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.ACCEPT)
			{
				grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Song Position " + (!FlxG.save.data.songPosition ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 0;
						grpControls.add(ctrl);
					case 1:
						FlxG.save.data.etternaMode = !FlxG.save.data.etternaMode;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Etterna Mode " + (!FlxG.save.data.etternaMode ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
					case 2:
						FlxG.save.data.itgPopupScore = !FlxG.save.data.itgPopupScore;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "ITG SCORE " + (!FlxG.save.data.itgPopupScore ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.fireNoteSupremacy = !FlxG.save.data.fireNoteSupremacy;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Experimental Mines " + (!FlxG.save.data.fireNoteSupremacy ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
				}
			}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play('assetss/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
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