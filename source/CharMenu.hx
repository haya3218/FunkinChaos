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
import Boyfriend.Boyfriend;
import Character.Character;
import HealthIcon.HealthIcon;
import flixel.ui.FlxBar;
typedef CharacterMenu = {
	var name:String;
	var characterName:String;
	var portrait:String;
}

class CharMenu extends MusicBeatState
{
	var menuItems:Array<String> = ['BOYFRIEND', 'BOYFRIENDSECOND', 'YAKUZA', 'BOXMAN', 'FUNNEMAN', 'DEFAULT'];
	var curSelected:Int = 0;
	var txtDescription:FlxText;
	var shitCharacter:FlxSprite;
	var shitCharacterBetter:Boyfriend;
	var icon:HealthIcon;
	var menuBG:FlxSprite;
	public static var SONG:SwagSong;
	public var targetY:Float = 0;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	public static var characterShit:Array<CharacterMenu>;

	private var grpMenuShit:FlxTypedGroup<Alphabet>;
	private var grpMenuShiz:FlxTypedGroup<FlxSprite>;
	var alreadySelectedShit:Bool = false;
	var doesntExist:Bool = false;

	var shittyNames:Array<String> = [
		"BOYFRIEND",
		"SOMEONE HELP ME I AM IN DANGER",
		"FUNNE MAN KIL FUNNE MAN",
		"BOX",
		"THE LOUD GUY",
		"DEFAULT"
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

		shitCharacter = new FlxSprite(0, -20);
		shitCharacter.scale.set(0.45, 0.45);
		shitCharacter.updateHitbox();
		shitCharacter.screenCenter(XY);
		shitCharacter.antialiasing = true;
		shitCharacter.y += 30;
		add(shitCharacter);

		shitCharacterBetter = new Boyfriend(0, 0, 'bf');

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
		if (txtOptionTitle.text == '')
		{
			trace('NO FUCKING TEXT LMAO');
			txtOptionTitle.text = 'NO DESCRIPTION';
		}

		if (shitCharacterBetter.animation.curAnim.name == 'idle' && shitCharacterBetter.animation.curAnim.finished && doesntExist)
			shitCharacterBetter.playAnim('idle', true);
			
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
					FlxFlicker.flicker(shitCharacter, 0);
					FlxFlicker.flicker(shitCharacterBetter, 0);
					PlayState.hasPlayedOnce = true;
					if (shitCharacterBetter.animOffsets.exists('hey'))
						shitCharacterBetter.playAnim('hey');
					else
						shitCharacterBetter.playAnim('singUP');
		
					switch (daSelected)
					{
						case "BOYFRIENDSECOND":
							FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							PlayState.SONG.player1 = 'diva';
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
						case 'BOXMAN':
							FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							PlayState.SONG.player1 = 'bf-boxman';
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new PlayState());
							});
						case 'YAKUZA':
							FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							PlayState.SONG.player1 = 'bf-yakuza';
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								FlxG.switchState(new PlayState());
							});
						case 'FUNNEMAN':
							FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							PlayState.SONG.player1 = 'luci-moment';
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
					if (OptionsHandler.options.modifierMenu)
						FlxG.switchState(new ModifierState());
					else {
						if (PlayState.isStoryMode)
							FlxG.switchState(new StoryMenuState());
			
					//Tell the menu to actually go back to the one you were before. Y'all lazy lol
					else if (PlayState.isBSidesMode)
							FlxG.switchState(new BSidesState());
					else if (PlayState.isShitpostMode)
							FlxG.switchState(new CustomSongState());
			
					else
						{
							if (PlayState.isCreditsMode)
								FlxG.switchState(new OptionsMenu());
							else
								FlxG.switchState(new FreeplayState());
						}
					}
						
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
		doesntExist = false;
		var daSelected:String = menuItems[curSelected];
		var storedColor:FlxColor = 0xFFFFFF;
		var charSelected:String = 'bf';
		remove(shitCharacterBetter);
		remove(icon);

		switch (daSelected)
		{
			case "BOXMAN":
				charSelected = 'bf-boxman';
				menuBG.loadGraphic('assets/images/charSelect/BG4.png');
				menuBG.color = 0x87ceeb;
			case "BOYFRIEND":
				charSelected = 'bf';
				menuBG.loadGraphic('assets/images/charSelect/BG1.png');
				menuBG.color = 0xFFFFFF;
			case "BOYFRIENDSECOND":
				charSelected = 'diva';
				menuBG.loadGraphic('assets/images/charSelect/BG4.png');
				menuBG.color = 0xEE82EE;
			case "YAKUZA":
				charSelected = 'bf-yakuza';
				menuBG.loadGraphic('assets/images/charSelect/BG4.png');
				menuBG.color = 0xFF0000;
			case "FUNNEMAN":
				charSelected = 'luci-moment';
				menuBG.loadGraphic('assets/images/charSelect/BG4.png');
				menuBG.color = 0xFF00FF;
			case 'DEFAULT':
				charSelected = 'bf';
				menuBG.loadGraphic('assets/images/charSelect/BG4.png');
				menuBG.color = 0xFFFFFF;
				storedColor = 0x000000;
			default:
				// so it doesnt crash lol
				charSelected = 'bf';
				menuBG.loadGraphic('assets/images/charSelect/BG4.png');
				menuBG.color = 0xFFFFFF;
		}

		shitCharacter.updateHitbox();
		shitCharacter.screenCenter(XY);

		shitCharacterBetter = new Boyfriend(0, 0, charSelected);
		shitCharacterBetter.scale.set(0.7, 0.7);
		shitCharacterBetter.screenCenter(XY);
		shitCharacterBetter.antialiasing = true;
		shitCharacterBetter.playAnim('idle', true);
		shitCharacterBetter.color = storedColor;
		add(shitCharacterBetter);

		doesntExist = true;

		var healthBarBG:FlxSprite = new FlxSprite(0, FlxG.height * 0.9).loadGraphic('assets/images/healthBar.png');
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = false;
		add(healthBarBG);
	
		var healthBar:FlxBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		healthBar.visible = false;
			// healthBar
		add(healthBar);
		icon = new HealthIcon(charSelected, true);
		icon.y = healthBar.y - (icon.height / 2);
		icon.screenCenter(X);
		icon.setGraphicSize(-4);
		icon.y -= 20;
		add(icon);
	}
}