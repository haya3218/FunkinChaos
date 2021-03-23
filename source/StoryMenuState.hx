package;

import flixel.system.FlxSound;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import lime.net.curl.CURLCode;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;
	var levelInfo:FlxText;
	var isLuci:Bool;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['Bopeebo', 'Fresh', 'Dadbattle'],
		['Spookeez', 'South', "Monster"],
		['Pico', 'Philly', "Blammed"],
		['Satin-Panties', "High", "Milf"],
		['Cocoa', 'Eggnog', 'Winter-Horrorland'],
		['Senpai', 'Roses', 'Thorns'],
		['Smash', 'Ridge'],
		['Judgement', 'Machine-Gun-Kiss', 'Friday-Night'],
		['Luci-Moment', 'Disappear'],
		['MC-MENTAL-AT-HIS-BEST', 'MTC', 'Hell'],
		['Smash'],
		['Good-Enough', 'Lover', 'Tug-Of-War', 'Animal']
	];
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['dad', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['spooky', 'bf', 'gf'],
		['pico', 'bf', 'gf'],
		['mom', 'bf', 'gf'],
		['parents-christmas', 'bf', 'gf'],
		['senpai', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['jay', 'luci', 'bishop'],
		['jay', 'luci', 'bishop'],
		['dad', 'bf', 'gf'],
		['annie', 'bf', 'gf']
	];

	var weekNames:Array<String> = [
		"",
		"Daddy Dearest",
		"Spooky Month",
		"PICO",
		"MOMMY MUST MURDER",
		"RED SNOW",
		"hating simulator ft. moawling",
		"WHERE'S YOUR LIFE LICENSE?",
		"GAME ABOUT GANGSTERS DOING BAD THINGS",
		"LUCI STOOPID",
		"LUCI STOOPID PART 2",
		"FUNNE",
		""
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var rankText:FlxText;
	var autoModeSelected:Bool = false;

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu', 'shared'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		rankText = new FlxText(0, FlxG.height - 32);
		rankText.setFormat("assets/fonts/vcr.ttf", 32);
		rankText.size = scoreText.size;
		rankText.alpha = 0.7;

		var ui_tex = FlxAtlasFrames.fromSparrow('assets/images/campaign_menu_UI_assets.png', 'assets/images/campaign_menu_UI_assets.xml');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0 + 5, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
	
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();
	
			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Story Menu", null);
		#end

		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[curWeek][char]);
			weekCharacterThing.y += 70;
			weekCharacterThing.antialiasing = true;
			switch (weekCharacterThing.character)
			{
				case 'dad':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
				case 'jay':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
				case 'bf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
					weekCharacterThing.x -= 80;
					isLuci = false;
				case 'luci':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
					weekCharacterThing.x -= 80;
					isLuci = true;
				case 'gf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
					isLuci = false;
				case 'bishop':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
					isLuci = false;
				case 'parents-christmas':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
					isLuci = false;
				default:
					isLuci = false;
			}
	
			grpWeekCharacters.add(weekCharacterThing);
		}

		trace("Line 96");

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 20, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('hell', 'HELL');
		sprDifficulty.animation.play('normal');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		
		add(yellowBG);
		add(grpWeekCharacters);

		levelInfo = new FlxText(20, scoreText.y, 0, "SOUND TEST", 32);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat('assets/fonts/vcr.ttf', 32, FlxColor.WHITE, RIGHT);
		levelInfo.updateHitbox();
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);

		txtTracklist = new FlxText(FlxG.width * 0.07, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		add(rankText);
		add(levelInfo);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		trace("Line 165");

		super.create();
	}

	var playingShit:Bool = false;

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);

				if (FlxG.keys.justPressed.CONTROL)
				{
					if (playingShit == false)
					{
						FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut});
						playingShit = true;
					}
					else if (playingShit == true)
					{
						FlxTween.tween(levelInfo, {alpha: 0, y: -20}, 0.4, {ease: FlxEase.quartInOut});
						playingShit = false;
					}
				}

				if (FlxG.keys.pressed.SHIFT)
				{
					rankText.text = 'AUTOPLAY';
					autoModeSelected = true;
				}
		
				if (FlxG.keys.justReleased.SHIFT)
				{
					rankText.text = '';
					autoModeSelected = false;
				}
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (playingShit == false)
			{
				if (stopspamming == false)
				{
					// character shit
					FlxG.sound.play('assets/sounds/confirmMenu' + weekCharacters[curWeek][1] + TitleState.soundExt);

					switch (curDifficulty)
					{
						case 1:
							grpWeekText.members[curWeek].startFlashing();
						case 2:
							if (curDifficulty == 2 && weekData[curWeek][0] != 'MC-MENTAL-AT-HIS-BEST' && weekData[curWeek][1] != 'MTC' && weekData[curWeek][2] != 'Hell')
								grpWeekText.members[curWeek].startFlashingRed();
							else if (curDifficulty == 2)
								grpWeekText.members[curWeek].startFlashing();
						case 3:
							grpWeekText.members[curWeek].startFlashingRed();
					}
					
					grpWeekCharacters.members[1].animation.play(weekCharacters[curWeek][1] + 'Confirm');
					stopspamming = true;
				}

				PlayState.storyPlaylist = weekData[curWeek];
				PlayState.isStoryMode = true;
				selectedWeek = true;

				var diffic = "";

				switch (curDifficulty)
				{
					case 2:
						diffic = '-hard';
					case 3:
						diffic = '-hell';
				}

				PlayState.storyDifficulty = curDifficulty;
				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.storyWeek = curWeek;
				PlayState.campaignScore = 0;
				PlayState.autoMode = autoModeSelected;
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (OptionsHandler.options.modifierMenu)
						FlxG.switchState(new ModifierState());
					else
						FlxG.switchState(new PlayState());
				});
			}
			else if (playingShit == true)
			{
				audioJungle(0);
			}
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (weekData[curWeek][0] != 'MC-MENTAL-AT-HIS-BEST' && weekData[curWeek][1] != 'MTC' && weekData[curWeek][2] != 'Hell')
		{
			if (curDifficulty < 1)
				curDifficulty = 3;
			if (curDifficulty > 3)
				curDifficulty = 1;
		}
		else
		{
			curDifficulty = 2;
			sprDifficulty.animation.play('hard');
			sprDifficulty.offset.x = 20;
			sprDifficulty.offset.y = 0;
			if (curDifficulty < 2)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 2;
		}

		if (weekData[curWeek][0] == 'Friday-Night' || weekData[curWeek][0] == 'Smash' || weekData[curWeek][0] == 'Luci-Moment' || weekData[curWeek][0] == 'Good-Enough')
		{
			if (curDifficulty < 1)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 1;
		}

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
				sprDifficulty.offset.y = 0;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
				sprDifficulty.offset.y = 0;
			case 3:
				sprDifficulty.animation.play('hell');
				sprDifficulty.offset.x = 20;
				sprDifficulty.offset.y = -2;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].animation.play(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].animation.play(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].animation.play(weekCharacters[curWeek][2]);
		txtTracklist.text = "Tracks\n";

		switch (grpWeekCharacters.members[0].animation.curAnim.name)
		{
			case 'parents-christmas':
				grpWeekCharacters.members[0].offset.set(200, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 0.99));

			case 'senpai':
				grpWeekCharacters.members[0].offset.set(130, 0);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1.4));

			case 'mom':
				grpWeekCharacters.members[0].offset.set(100, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

			case 'dad':
				grpWeekCharacters.members[0].offset.set(120, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

			case 'jay':
				grpWeekCharacters.members[0].offset.set(120, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

			default:
				grpWeekCharacters.members[0].offset.set(100, 100);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
				// grpWeekCharacters.members[0].updateHitbox();
		}

		var stringThing:Array<String> = weekData[curWeek];

		if (weekData[curWeek][0] != 'MC-MENTAL-AT-HIS-BEST' && weekData[curWeek][1] != 'MTC' && weekData[curWeek][2] != 'Hell')
		{
			for (i in stringThing)
			{
				txtTracklist.text += "\n" + i;
			}
		
			txtTracklist.text = txtTracklist.text.toUpperCase();
		
			txtTracklist.screenCenter(X);
			txtTracklist.x += 415;
		}
		else
		{
			txtTracklist.text += "\n" + '??????' + "\n" + '??????' + "\n" + '??????';
			
			txtTracklist.text = txtTracklist.text.toUpperCase();
			
			txtTracklist.screenCenter(X);
			txtTracklist.x += 415;
		}

		if (weekData[curWeek][0] == 'MC-MENTAL-AT-HIS-BEST' && weekData[curWeek][1] == 'MTC' && weekData[curWeek][2] == 'Hell')
			if (curDifficulty != 2)
				changeDifficulty();

		if (weekData[curWeek][0] == 'Friday-Night' || weekData[curWeek][0] == 'Smash' || weekData[curWeek][0] == 'Luci-Moment' || weekData[curWeek][0] == 'Good-Enough')
			if (curDifficulty == 3)
				changeDifficulty(-1);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	var voices:FlxSound;

	function audioJungle(curSong:Int, allowVoices:Bool = false)
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic('assets/music/' + weekData[curWeek][curSong] + '_Inst' + '.ogg');
			if (allowVoices)
				voices = new FlxSound().loadEmbedded('assets/music/' + weekData[curWeek][curSong] + '_Voices' + '.ogg');
		}
	}
}
