package;

import haxe.rtti.CType.Abstractdef;
import flash.text.TextField;
import Section.SwagSection;
import flixel.FlxState;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import haxe.Json;

class RemixState extends MusicBeatState
{
	var menuItems:Array<String> = ['DEFAULT', 'BSIDES', 'CUSTOM'];
	var curSelected:Int = 0;
	var txtDescription:FlxText;
	var remixCharacter:FlxSprite;
	var menuBG:FlxSprite;
	public static var SONG:SwagSong;
	public var targetY:Float = 0;

	private var grpMenuShit:FlxTypedGroup<Alphabet>;
	private var grpMenuShiz:FlxTypedGroup<FlxSprite>;
	var alreadySelectedShit:Bool = false;

	var shittyNames:Array<String> = [
		"DEFAULT",
		"B-SIDES FT. CVAL, ROZEBUD, JADS",
		"SHITPOSTS FT. EVERYONE"
	];

	

	var txtOptionTitle:FlxText;

	override function create()
	{
		menuBG = new FlxSprite().loadGraphic('assets/images/remixSelect/BG1.png');
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		grpMenuShiz = new FlxTypedGroup<FlxSprite>();
		add(grpMenuShiz);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.screenCenter(X);
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		txtDescription = new FlxText(FlxG.width * 0.075, menuBG.y + 200, 0, "", 32);
		txtDescription.alignment = CENTER;
		txtDescription.setFormat("assets/fonts/vcr.ttf", 32);
		txtDescription.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5, 1);
		txtDescription.color = FlxColor.WHITE;
		add(txtDescription);

		remixCharacter = new FlxSprite(0, -20);
		remixCharacter.frames = FlxAtlasFrames.fromSparrow('assets/images/remixSelect/menubop.png', 'assets/images/remixSelect/menubop.xml');
		remixCharacter.animation.addByPrefix('dancenormal', 'menu normal', 24);
		remixCharacter.animation.addByPrefix('dancebside', 'menu bside', 24);
		remixCharacter.animation.addByPrefix('danceshitpost', 'menu shitpost', 24);
		remixCharacter.animation.play('dancenormal');
		remixCharacter.scale.set(0.7, 0.7);
		remixCharacter.updateHitbox();
		remixCharacter.screenCenter(XY);
		remixCharacter.antialiasing = true;
		add(remixCharacter);

		var remixSelHeaderText:Alphabet = new Alphabet(0, 50, 'SELECT REMIX', true, false);
		remixSelHeaderText.screenCenter(X);
		add(remixSelHeaderText);

		var shittyArrows:FlxSprite = new FlxSprite().loadGraphic('assets/images/remixSelect/arrowsz.png');
		shittyArrows.screenCenter();
		shittyArrows.antialiasing = true;
		add(shittyArrows);

		txtOptionTitle = new FlxText(FlxG.width * 0.7, 10, 0, "dfgdfgdg", 32);
		txtOptionTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtOptionTitle.alpha = 0.7;
		add(txtOptionTitle);

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	override function update(elapsed:Float)
	{
		txtOptionTitle.text = shittyNames[curSelected].toUpperCase();
		txtOptionTitle.x = FlxG.width - (txtOptionTitle.width + 10);
		if (txtOptionTitle.text == '')
		{
			trace('Test');
			txtOptionTitle.text = 'wtf';
		}

		var upP = controls.LEFT_P;
		var downP = controls.RIGHT_P;
		var accepted = controls.ACCEPT;

		if (!alreadySelectedShit)
		{
			if (upP)
				{
					changeSelection(-1);
				}
				if (downP)
				{
					changeSelection(1);
				}
		
				if (accepted)
				{
					alreadySelectedShit = true;
					var daSelected:String = menuItems[curSelected];
					FlxFlicker.flicker(remixCharacter, 0);
					
		
					switch (daSelected)
					{
						case "DEFAULT":
							FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new FreeplayState());
							});
						case "BSIDES":
							FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new BSidesState());
							});
						case "CUSTOM":
							FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new CustomSongState());
							});
					
						default:
							// so it doesnt crash lol
							
					}
				}
		
				if (controls.BACK)
					FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;
	
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;
	
		var bullShit:Int = 0;
	
		for (item in grpMenuShit.members)
		{
			item.x = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;
			// item.setGraphicSize(Std.int(item.width * 0.8));
	
			if (item.x == 0)
			{
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		charCheckLmao();
	}

	function charCheckLmao()
	{
		var daSelected:String = menuItems[curSelected];

		switch (daSelected)
		{
			case "DEFAULT":
				remixCharacter.animation.play('dancenormal');
				
				menuBG.color = 0xFFFFFF;
			case "BSIDES":
				remixCharacter.animation.play('dancebside');
				case "CUSTOM":
				remixCharacter.animation.play('danceshitpost');
				
			default:
				remixCharacter.animation.play('dancenormal');
					
				menuBG.color = 0xFFFFFF;
		}
	}
}