package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var bg:FlxSprite;
	var songs:Array<String> = [];
	var songText:Alphabet;
	var scoreBG:FlxSprite;

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var currentAlbum:Bool;
	var isDebug:Bool;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	override function create()
	{
		// LOAD MUSIC
		songs = CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt');

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			}
		 */

		isDebug = false;

		#if debug
		isDebug = true;
		#end

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic('assets/images/menuBGBlue.png');
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			songText = new Alphabet(0, (70 * i) + 30, songs[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		

		changeSelection();
		changeDiff();

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
		super.update(elapsed);

		if (!currentAlbum)
			songs = CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt');
		else
			songs = CoolUtil.coolTextFile('assets/data/customSonglist.txt');

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (songs[curSelected] != 'CUSTOM-SONGS')
		{
			scoreText.text = "PERSONAL BEST:" + lerpScore;
			add(scoreBG);
			add(diffText);
			add(scoreText);
		}
		else
		{
			scoreText.text = "";
			remove(scoreBG);
			remove(diffText);
			remove(scoreText);
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

		if (songs[curSelected] != 'CUSTOM-SONGS')
		{
			if (controls.LEFT_P)
				changeDiff(-1);
			if (controls.RIGHT_P)
				changeDiff(1);
		}

		if (controls.BACK)
		{
			FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase(), curDifficulty);

			trace(poop);

			if (songs[curSelected] != 'CUSTOM-SONGS')
			{
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.isCreditsMode = false;
				PlayState.storyDifficulty = curDifficulty;
				FlxG.switchState(new ModifierState());
			}
			else
				FlxG.switchState(new CustomSongsState());
		}

		/*
		if (FlxG.keys.justPressed.I)
			changeAlbum();
		*/
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 3;
		if (curDifficulty > 3)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
			case 3:
				diffText.text = "HELLBEATS PLS NO";
		}
	}

	function changeSelection(change:Int = 0)
	{
		// #if !switch
		// NGio.logEvent('Fresh');
		// #end

		// NGio.logEvent('Fresh');
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		// lerpScore = 0;
		#end

		if (songs[curSelected] != 'CUSTOM-SONGS')
			FlxG.sound.playMusic('assets/music/' + songs[curSelected] + "_Inst" + TitleState.soundExt, 0);

		var bullShit:Int = 0;

		for (item in grpSongs.members)
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

	// shitty fuckshit doesnt work (unused lmaoooo)
	/*
	function changeAlbum()
	{
		currentAlbum = !currentAlbum;
		grpSongs.remove(songText);
		remove(grpSongs);
		for (i in 0...songs.length)
		{
			songText = new Alphabet(0, (70 * i) + 30, songs[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		add(grpSongs);
		changeSelection();
		changeDiff();
	}
	*/
}
