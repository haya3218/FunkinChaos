package;

#if desktop
import Discord.DiscordClient;
#end
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.system.macros.FlxMacroUtil;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.utils.Assets;

class ControlMenu extends MusicBeatState
{
	var selector:FlxText;
	var scoreText:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];
	var shittyAdons:Array<String> = ['DFJK INPUT', 'WASD INPUT', 'IJKL INPUT'];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var changingInput:Bool = false;
  
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assetss/images/menuDesat.png');
		controlsStrings = CoolUtil.coolTextFile('assetss/data/controls.txt');
		menuBG.color = 0x32CD32;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);
		var i = 0;

		selector = new FlxText(0, 0, 0, "", 100);
		selector.setFormat("assetss/fonts/funke.otf", 75, FlxColor.WHITE, CENTER);
		selector.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5.5, 5.5);
		add(selector);
		selector.visible = false;

		scoreText = new FlxText(FlxG.width * 0.77, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assetss/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Control Menu", null);
		#end


		for(key => value in Controls.keyboardMap)
		{
			var elements:Array<String> = controlsStrings[i].split(',');
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30,'1' + key + ': ' + value, true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			controlLabel.visible = true;
			grpControls.add(controlLabel);
			i++;
		}

		for (i in 0...shittyAdons.length)
		{
			var setLabel:Alphabet = new Alphabet(0, (70 * i) + 30,shittyAdons[i], true, false);
			setLabel.isMenuItem = true;
			setLabel.targetY = i;
			setLabel.visible = true;

			grpControls.add(setLabel);
		}

		var charSelHeaderText:Alphabet = new Alphabet(0, 50, 'CUSTOMIZE CONTROLS', true, false);
		charSelHeaderText.screenCenter(X);
		add(charSelHeaderText);
		
		//for (i in 0...controlsStrings.length)
		//{
		//	
		//	var elements:Array<String> = controlsStrings[i].split(',');
		//	var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30,'set ' + elements[0] + ': ' + elements[1], true, false);
		//	controlLabel.isMenuItem = true;
		//	controlLabel.targetY = i;
		//	grpControls.add(controlLabel);
		//	
		//	// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		//}

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(!changingInput)
		{
			if (controls.BACK)
			{
				FlxG.sound.play('assetss/sounds/cancelMenu' + TitleState.soundExt);
				FlxG.switchState(new OptionsMenu());
				Controls.saveControls();
				controls.setKeyboardScheme(Solo,true);
			}
			if(controls.UP_P)
				changeSelection(-1);
			if(controls.DOWN_P)
				changeSelection(1);
			if(controls.ACCEPT)
			{
				changeInput();
			}
		}
		else
		{
			inputChange();
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assetss/sounds/scrollMenu' + TitleState.soundExt);

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

		showKeyShit();
	}

	function changeInput()
	{
		FlxG.sound.play('assetss/sounds/cancelMenu' + TitleState.soundExt);
		switch (grpControls.members[curSelected].text)
		{
			case 'DFJK INPUT':
				Controls.keyboardMap.set('UP',J);
				Controls.keyboardMap.set('DOWN',F);
				Controls.keyboardMap.set('LEFT',D);
				Controls.keyboardMap.set('RIGHT',K);
				Controls.saveControls();
				controls.setKeyboardScheme(Solo,true);
				FlxG.switchState(new OptionsMenu());
			case 'WASD INPUT':
				Controls.keyboardMap.set('UP',W);
				Controls.keyboardMap.set('DOWN',S);
				Controls.keyboardMap.set('LEFT',A);
				Controls.keyboardMap.set('RIGHT',D);
				Controls.saveControls();
				controls.setKeyboardScheme(Solo,true);
				FlxG.switchState(new OptionsMenu());
			case 'IJKL INPUT':
				Controls.keyboardMap.set('UP',I);
				Controls.keyboardMap.set('DOWN',K);
				Controls.keyboardMap.set('LEFT',J);
				Controls.keyboardMap.set('RIGHT',L);
				Controls.saveControls();
				controls.setKeyboardScheme(Solo,true);
				FlxG.switchState(new OptionsMenu());
			default:
				changingInput = true;
				FlxFlicker.flicker(grpControls.members[curSelected],0);
		}
		
	}

	function inputChange()
	{			
		var i = 0;	
		if(FlxG.keys.pressed.ANY)
		{
			//Checks all known keys
			var keyMaps:Map<String, FlxKey> = FlxMacroUtil.buildMap("flixel.input.keyboard.FlxKey");
			for(key in keyMaps.keys())
			{
				if(FlxG.keys.checkStatus(key,2) && key != "ANY")
				{			
					FlxG.sound.play('assetss/sounds/confirmMenu' + TitleState.soundExt);		
					FlxFlicker.stopFlickering(selector);
					
					var elements:Array<String> = grpControls.members[curSelected].text.split(':');
					var name:String = StringTools.replace(elements[0],'1','');
					var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30,'1' + name + ': ' + key, true, false);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i;
					controlLabel.visible = true;

					grpControls.replace(grpControls.members[curSelected],controlLabel);
					changingInput = false;

					var daSelected:String = grpControls.members[curSelected].text.toUpperCase();

					selector.text = daSelected;
					selector.screenCenter(XY);
					
					Controls.keyboardMap.set(name,keyMaps[key]);
					FlxG.log.add(name + " is bound to " + keyMaps[key]);
					break;
				}
			}			

		}
	}

	function showKeyShit()
	{
		var daSelected:String = grpControls.members[curSelected].text.toUpperCase();

		selector.text = daSelected;
		selector.screenCenter(XY);
	}
}