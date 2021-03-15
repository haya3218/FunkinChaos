package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;
	var soundPerChar:String = '';

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitRightGF:FlxSprite;
	var portraitLeft2:FlxSprite;
	var portraitLeft3:FlxSprite;
	var portraitLeft4:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic('assets/music/Lunchbox' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'roses':
				trace('MUSIC IS ALREADY PLAYING!');
			case 'thorns':
				FlxG.sound.playMusic('assets/music/LunchboxScary' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'luci-moment':
				trace('MUSIC IS ALREADY PLAYING!');
			case 'disappear':
				FlxG.sound.playMusic('assets/music/LunchboxScary' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			default:
				FlxG.sound.playMusic('assets/music/title' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'roses')
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpaiPortrait.png', 'assets/images/weeb/senpaiPortrait.xml');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
		}
		else if (PlayState.SONG.song.toLowerCase() == 'tutorial')
		{
			portraitLeft = new FlxSprite(0, 20);
			portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/gfPortraitEnemy.png', 'assets/images/gfPortrait.xml');
			portraitLeft.animation.addByPrefix('enter', 'GF portrait enter', 24, false);
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
		}
		else 
		{
			portraitLeft = new FlxSprite(0, 20);
			portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/dadPortrait.png', 'assets/images/dadPortrait.xml');
			portraitLeft.animation.addByPrefix('enter', 'Dad Portrait Enter', 24, false);
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
		}
		add(portraitLeft);
		portraitLeft.visible = false;

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'roses')
		{
			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPortrait.png', 'assets/images/weeb/bfPortrait.xml');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
		}
		else
		{
			portraitRight = new FlxSprite(0, 20);
			portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/bfPortrait.png', 'assets/images/bfPortrait.xml');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend Portrait Enter', 24, false);
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
		}
		add(portraitRight);
		portraitRight.visible = false;

		portraitRightGF = new FlxSprite(0, 20);
		portraitRightGF.frames = FlxAtlasFrames.fromSparrow('assets/images/gfPortrait.png', 'assets/images/gfPortrait.xml');
		portraitRightGF.animation.addByPrefix('enter', 'GF portrait enter', 24, false);
		portraitRightGF.updateHitbox();
		portraitRightGF.scrollFactor.set();
		add(portraitRightGF);
		portraitRightGF.visible = false;

		portraitLeft2 = new FlxSprite(0, 20);
		portraitLeft2.frames = FlxAtlasFrames.fromSparrow('assets/images/miku/portrait.png', 'assets/images/miku/portrait.xml');
		portraitLeft2.animation.addByPrefix('enter', 'Sample portrait enter', 24, false);
		portraitLeft2.updateHitbox();
		portraitLeft2.scrollFactor.set();
		add(portraitLeft2);
		portraitLeft2.visible = false;

		portraitLeft3 = new FlxSprite(0, 20);
		portraitLeft3.frames = FlxAtlasFrames.fromSparrow('assets/images/miku/brother.png', 'assets/images/miku/brother.xml');
		portraitLeft3.animation.addByPrefix('enter', 'Sample portrait enter', 24, false);
		portraitLeft3.updateHitbox();
		portraitLeft3.scrollFactor.set();
		add(portraitLeft3);
		portraitLeft3.visible = false;

		portraitLeft4 = new FlxSprite(0, 20);
		portraitLeft4.frames = FlxAtlasFrames.fromSparrow('assets/images/miku/mysterious.png', 'assets/images/miku/mysterious.xml');
		portraitLeft4.animation.addByPrefix('enter', 'Sample portrait enter', 24, false);
		portraitLeft4.updateHitbox();
		portraitLeft4.scrollFactor.set();
		add(portraitLeft4);
		portraitLeft4.visible = false;

		box = new FlxSprite(345, 45);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'bopeebo':
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/speech_bubble_talking.png',
				'assets/images/speech_bubble_talking.xml');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);

			case 'senpai':
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-pixel.png',
					'assets/images/weeb/pixelUI/dialogueBox-pixel.xml');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				FlxG.sound.play('assets/sounds/ANGRY_TEXT_BOX' + TitleState.soundExt);

				box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-senpaiMad.png',
					'assets/images/weeb/pixelUI/dialogueBox-senpaiMad.xml');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-evil.png', 'assets/images/weeb/pixelUI/dialogueBox-evil.xml');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic('assets/images/weeb/spiritFaceForward.png');
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

			default:
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/speech_bubble_talking.png',
				'assets/images/speech_bubble_talking.xml');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);
		}

		box.animation.play('normalOpen');
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'roses')
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		else
		{
			box.y += 320;
			box.x += 500;
		}
		box.updateHitbox();
		add(box);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic('assets/images/weeb/pixelUI/hand_textbox.png');
		add(handSelect);

		box.screenCenter(X);
		if (PlayState.SONG.song.toLowerCase() != 'senpai' || PlayState.SONG.song.toLowerCase() != 'thorns' || PlayState.SONG.song.toLowerCase() != 'roses')
			box.x += 50;
		portraitLeft.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		var font:String = '';
		
		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		switch (PlayState.curStage)
		{
			case 'school':
				font = 'Pixel Arial 11 Bold';
			case 'schoolEvil':
				font = 'Pixel Arial 11 Bold';
			default:
				font = 'assets/fonts/vcr.ttf';

		}
		dropText.font = font;
		dropText.color = 0xFFD89494;
		
		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.font = dropText.font;
		add(dropText);
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);

		this.dialogueList = dialogueList;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	var allowBoxFlipping:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				swagDialogue.color = 0xFF3F2021;
				dropText.color = 0xFFD89494;
				allowBoxFlipping = false;
			case 'roses':
				swagDialogue.color = 0xFF3F2021;
				dropText.color = 0xFFD89494;
				portraitLeft.visible = false;
				allowBoxFlipping = false;
			case 'thorns':
				portraitLeft.color = FlxColor.BLACK;
				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
				allowBoxFlipping = false;
			default:
				swagDialogue.color = FlxColor.BLACK;
				dropText.color = FlxColor.GRAY;
				allowBoxFlipping = true;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.SPACE  && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						portraitRightGF.visible = false;
						portraitLeft2.visible = false;
						portraitLeft2.visible = false;
						portraitLeft3.visible = false;
						portraitLeft4.visible = false;

						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		if (PlayState.SONG.song.toLowerCase() != 'senpai' || PlayState.SONG.song.toLowerCase() != 'thorns' || PlayState.SONG.song.toLowerCase() != 'roses')
		{
			switch (curCharacter)
			{
				case 'dad':
					if (PlayState.SONG.song.toLowerCase() != 'luci-moment')
						soundPerChar = 'dearestText';
					else
						soundPerChar = 'mikuText';
				case 'bf':
					soundPerChar = 'boyfriendText';
				case 'gf':
					soundPerChar = 'gfText';
			}
		}
		switch (curCharacter)
		{
			case 'dad':
				soundPerChar = 'dearestText';
			case 'brother':
				soundPerChar = 'dearestText';
			case 'carlos':
				soundPerChar = 'dearestText';
			case 'bf':
				soundPerChar = 'boyfriendText';
			case 'gf':
				soundPerChar = 'gfText';
			case 'miku':
				soundPerChar = 'mikuText';
		}
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'roses')
		{
			soundPerChar = 'pixelText';
		}
		swagDialogue.sounds = [FlxG.sound.load('assets/sounds/' + soundPerChar + TitleState.soundExt, 0.6)];
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				portraitRightGF.visible = false;
				portraitLeft2.visible = false;
				portraitLeft3.visible = false;
				portraitLeft4.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					if (allowBoxFlipping)
						box.flipX = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				portraitRightGF.visible = false;
				portraitLeft2.visible = false;
				portraitLeft3.visible = false;
				portraitLeft4.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					if (allowBoxFlipping)
						box.flipX = false;
					portraitRight.animation.play('enter');
				}
			case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeft2.visible = false;
				portraitLeft3.visible = false;
				portraitLeft4.visible = false;
				if (!portraitRightGF.visible)
				{
					portraitRightGF.visible = true;
					if (allowBoxFlipping)
						box.flipX = false;
					portraitRightGF.animation.play('enter');
				}
			case 'miku':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitRightGF.visible = false;
				portraitLeft3.visible = false;
				portraitLeft4.visible = false;
				if (!portraitLeft2.visible)
				{
					portraitLeft2.visible = true;
					if (allowBoxFlipping)
						box.flipX = true;
					portraitLeft2.animation.play('enter');
				}
			case 'brother':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitRightGF.visible = false;
				portraitLeft2.visible = false;
				portraitLeft4.visible = false;
				if (!portraitLeft3.visible)
				{
					portraitLeft3.visible = true;
					if (allowBoxFlipping)
						box.flipX = true;
					portraitLeft3.animation.play('enter');
				}
			case 'carlos':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitRightGF.visible = false;
				portraitLeft2.visible = false;
				portraitLeft3.visible = false;
				if (!portraitLeft4.visible)
				{
					portraitLeft4.visible = true;
					if (allowBoxFlipping)
						box.flipX = true;
					portraitLeft4.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
