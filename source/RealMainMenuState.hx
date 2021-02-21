package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flash.system.System;
#if sys
import sys.io.File;
#end
import haxe.Json;
using StringTools;
class RealMainMenuState extends MusicBeatState
{
	var menuItem:FlxSprite;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var menuItemSprite:Array<FlxSprite> = [];
	var menuSht:Array<String> = ['1', '2', '3'];
	var grpAlphabet:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
	var checkmarks:Array<FlxSprite> = [];
	var multiTxt:FlxText;
	var txtTitle:FlxText;
	var txtDescription:FlxText;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var alreadySelectedShit:Bool = false;
	public static var scoreMultiplier:Float = 1;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0x379708;
		grpAlphabet = new FlxTypedGroup<Alphabet>();
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		multiTxt = new FlxText(800, 60, 0, "", 200);
		multiTxt.setFormat("assets/fonts/vcr.ttf", 40, FlxColor.WHITE, RIGHT);
		multiTxt.text = "Multiplier: 1";
		multiTxt.scrollFactor.set();

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuBG.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic('assets/images/menuDesat.png');
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		var tex = FlxAtlasFrames.fromSparrow('assets/images/FNF_rel_menu_assets.png', 'assets/images/FNF_rel_menu_assets.xml');

		for (i in 0...menuSht.length) {
			var swagModifier = new Alphabet(0, 0, menuSht[i], true, false);
			swagModifier.isOptionItem = true;
			swagModifier.invisModifier = true;
			swagModifier.screenCenter(X);
			swagModifier.targetY = i;
			menuItem = new FlxSprite(0, 0);
			menuItem.frames = tex;
            menuItem.animation.addByPrefix('Idle', menuSht[i] + " basic", 24, true);
            menuItem.animation.addByPrefix('Select', menuSht[i] + " white", 24, true);
			menuItem.animation.play('Idle');
			menuItem.ID = i;
			menuItem.scrollFactor.set();
			menuItem.screenCenter(XY);
			menuItem.x -= 750;
			menuItem.y -= 300;
			menuItemSprite.push(menuItem);
			swagModifier.add(menuItem);
			grpAlphabet.add(swagModifier);
		}
		add(grpAlphabet);

		var bgHeader:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuBGMenu.png');
		bgHeader.screenCenter();
		bgHeader.antialiasing = true;
		add(bgHeader);

		txtTitle = new FlxText(5, FlxG.height - 64, 0, "", 32);
		txtTitle.scrollFactor.set();
		txtTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5, 1);
		add(txtTitle);

		txtDescription = new FlxText(5, FlxG.height - 30, 0, "", 24);
		txtDescription.scrollFactor.set();
		txtDescription.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtDescription.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5, 1);
		add(txtDescription);

		txtTitle.text = 'SINGLEPLAYER MODE';
		txtDescription.text = 'Challenge an enemy to a beep bop rap battle!';

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (!selectedSomethin)
		{
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
						if (menuSht[curSelected] == 'donate')
							{
								#if linux
								Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
								#else
								FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
								#end
							}
							else
							{
								selectedSomethin = true;
								FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
			
								FlxFlicker.flicker(magenta, 1.1, 0.15, false);
								FlxFlicker.flicker(grpAlphabet.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									var daChoice:String = menuSht[curSelected];
			
									switch (daChoice)
									{
										case '1':
											FlxG.switchState(new MainMenuState());
										case '3':
											System.exit(0);
				
										case '2':
											FlxG.switchState(new OptionsMenu());
									}
								});
							}
					}
		}
	}
	function changeSelection(change:Int = 0)
	{

		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);

		curSelected += change;

		if (curSelected < 0)
			curSelected = menuSht.length - 1;
		if (curSelected >= menuSht.length)
			curSelected = 0;
	
		var bullShit:Int = 0;

		for (item in grpAlphabet.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		optionDescription();
	}

	function optionDescription()
	{
		var daDescription:String = menuSht[curSelected];
	
		switch (daDescription)
		{
			case '1':
				txtTitle.text = 'SINGLEPLAYER MODE';
				txtDescription.text = 'Challenge an enemy to a beep bop rap battle!';
			case '2':
				txtTitle.text = 'OPTIONS MENU';
				txtDescription.text = 'Edit your preferences here! (Currently doesnt save between sessions)';
			default:
				txtTitle.text = 'EXIT GAME';
				txtDescription.text = 'See ya next time!';
		}
	}
}