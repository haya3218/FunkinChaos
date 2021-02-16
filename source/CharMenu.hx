package;

import haxe.rtti.CType.Abstractdef;
import flash.text.TextField;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import haxe.Json;
typedef CharacterMenu = {
	var name:String;
	var characterName:String;
	var portrait:String;
}

class CharMenu extends MusicBeatState
{
	var menuItems:Array<String> = ['BOYFRIEND', 'BOYFRIENDSECOND', 'PICO', 'DEFAULT'];
	var curSelected:Int = 0;
	var txtDescription:FlxText;
	var shitCharacter:FlxSprite;
	var menuBG:FlxSprite;
	public static var SONG:SwagSong;
	public var targetY:Float = 0;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	public static var characterShit:Array<CharacterMenu>;

	private var grpMenuShit:FlxTypedGroup<Alphabet>;
	private var grpMenuShiz:FlxTypedGroup<FlxSprite>;

	var shittyNames:Array<String> = [
		"BOYFRIEND",
		"BOYFRIEND AS WELL",
		"PICO",
		"DEFAULT"
	];

	var weekCharacters:Array<Dynamic> = [
		['pico'],
		['bf']
	];

	var txtOptionTitle:FlxText;

	override function create()
	{
		menuBG = new FlxSprite().loadGraphic('assets/images/charSelect/BG4.png');
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
			songText.isOptionItem = true;
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

		shitCharacter = new FlxSprite(0, -20).loadGraphic('assets/images/charSelect/pissboyfriend.png');
		shitCharacter.setGraphicSize(-5);
		shitCharacter.screenCenter(XY);
		shitCharacter.updateHitbox();
		shitCharacter.antialiasing = true;
		shitCharacter.y += 40;
		add(shitCharacter);

		var charSelHeaderText:Alphabet = new Alphabet(0, 50, 'CHARACTER SELECT', true, false);
		charSelHeaderText.screenCenter(X);
		add(charSelHeaderText);

		var shittyArrows:FlxSprite = new FlxSprite().loadGraphic('assets/images/charSelect/arrowsz.png');
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
		
		var upP = controls.LEFT_P;
		var downP = controls.RIGHT_P;
		var accepted = controls.ACCEPT;

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
			var daSelected:String = menuItems[curSelected];
			FlxFlicker.flicker(shitCharacter, 0);

			switch (daSelected)
			{
				case "PICO":
					FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
					FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
					PlayState.SONG.player1 = 'pico';
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxG.switchState(new PlayState());
					});
				case "BOYFRIENDSECOND":
					FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
					FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
					PlayState.SONG.player1 = 'bf';
					if (PlayState.SONG.song.toLowerCase() == 'mtc')
						PlayState.SONG.player1 = 'bf-cursed';
					if (PlayState.SONG.song.toLowerCase() == 'friday-night' || PlayState.SONG.song.toLowerCase() == 'judgement' ||PlayState.SONG.song.toLowerCase() == 'machine-gun-kiss')
						PlayState.SONG.player1 = 'bf-yakuza';
					if (PlayState.SONG.song.toLowerCase() == 'satin-panties' || PlayState.SONG.song.toLowerCase() == 'high' || PlayState.SONG.song.toLowerCase() == 'milf')
						PlayState.SONG.player1 = 'bf-car';
					if (PlayState.SONG.song.toLowerCase() == 'cocoa' || PlayState.SONG.song.toLowerCase() == 'eggnog' || PlayState.SONG.song.toLowerCase() == 'winter-horrorland')
						PlayState.SONG.player1 = 'bf-christmas';
					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
						PlayState.SONG.player1 = 'bf-pixel';
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxG.switchState(new PlayState());
					});
				case "BOYFRIEND":
					FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
					FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
					PlayState.SONG.player1 = 'bf';
					if (PlayState.SONG.song.toLowerCase() == 'mtc')
						PlayState.SONG.player1 = 'bf-cursed';
					if (PlayState.SONG.song.toLowerCase() == 'friday-night' || PlayState.SONG.song.toLowerCase() == 'judgement' ||PlayState.SONG.song.toLowerCase() == 'machine-gun-kiss')
						PlayState.SONG.player1 = 'bf-yakuza';
					if (PlayState.SONG.song.toLowerCase() == 'satin-panties' || PlayState.SONG.song.toLowerCase() == 'high' || PlayState.SONG.song.toLowerCase() == 'milf')
						PlayState.SONG.player1 = 'bf-car';
					if (PlayState.SONG.song.toLowerCase() == 'cocoa' || PlayState.SONG.song.toLowerCase() == 'eggnog' || PlayState.SONG.song.toLowerCase() == 'winter-horrorland')
						PlayState.SONG.player1 = 'bf-christmas';
					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
						PlayState.SONG.player1 = 'bf-pixel';
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxG.switchState(new PlayState());
					});
				case 'DEFAULT':
					FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
					FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxG.switchState(new PlayState());
					});
				default:
					// so it doesnt crash lol
					trace('what the fuck');
			}
		}

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

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
			case "PICO":
				shitCharacter.loadGraphic('assets/images/charSelect/picodegallo.png');
				menuBG.loadGraphic('assets/images/charSelect/BG3.png');
				menuBG.color = 0xFFFFFF;
			case "BOYFRIEND":
				shitCharacter.loadGraphic('assets/images/charSelect/pissboyfriend.png');
				menuBG.loadGraphic('assets/images/charSelect/BG1.png');
				menuBG.color = 0xFFFFFF;
			case "BOYFRIENDSECOND":
				shitCharacter.loadGraphic('assets/images/charSelect/boyfriend.png');
				menuBG.loadGraphic('assets/images/charSelect/BG2.png');
				menuBG.color = 0x0351A3;
			case 'DEFAULT':
				shitCharacter.loadGraphic('assets/images/charSelect/defaultChar.png');
				menuBG.loadGraphic('assets/images/charSelect/BG4.png');
				menuBG.color = 0xFFFFFF;
			default:
				// so it doesnt crash lol
				shitCharacter.loadGraphic('assets/images/charSelect/defaultChar.png');
				menuBG.loadGraphic('assets/images/charSelect/BG4.png');
				menuBG.color = 0xFFFFFF;
		}
	}
}