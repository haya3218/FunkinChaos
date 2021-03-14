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
import lime.system.System;
import HealthIcon.HealthIcon;
#if sys
import sys.io.File;
import haxe.io.Path;
import openfl.utils.ByteArray;
import lime.media.AudioBuffer;
import sys.FileSystem;
import flash.media.Sound;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var bg:FlxSprite;
	var songs:Array<SongMetadata> = [];
	var songText:Alphabet;
	var scoreBG:FlxSprite;

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var fpText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var currentAlbum:Bool;
	var isDebug:Bool;

	var textObjects:Array<String> = [];

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	var rankText:FlxText;
	var autoModeSelected:Bool = false;
	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		textObjects = FlxG.random.getObject(CoolUtil.coolTextArray('assets/data/freeplayLangshit.txt'));

		// LOAD MUSIC
		
		addWeek(['Tutorial', 'Bopeebo', 'Fresh', 'Dadbattle'], 1, ['gf', 'dad', 'dad', 'dad']);

		addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']);

		addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);

		addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);

		addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit']);

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
			songText = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.77, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		fpText = new FlxText(scoreText.x + 120, 5, 0, "", 64);
		// scoreText.autoSize = false;
		fpText.setFormat("assets/fonts/vcr.ttf", 64, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		
		rankText = new FlxText(0, FlxG.height - 32);
		rankText.setFormat("assets/fonts/vcr.ttf", 32);
		rankText.size = scoreText.size;
		rankText.alpha = 0.7;

		changeSelection();
		changeDiff();
		add(scoreBG);
		add(diffText);
		add(scoreText);
		add(fpText);
		add(rankText);

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

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}
	
	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = textObjects[0];
		scoreText.text += lerpScore;

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

			if (controls.LEFT_P)
				changeDiff(-1);
			if (controls.RIGHT_P)
				changeDiff(1);

			if (controls.BACK)
				{
					FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
					FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
					FlxG.switchState(new RemixState());
				}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			

				var diffic = "";

				switch (curDifficulty)
				{
					case 3:
						diffic = '-hell';
				}

				PlayState.SONG = Song.loadFromJson(poop + diffic, songs[curSelected].songName.toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.isCreditsMode = false;
				PlayState.isBSidesMode = false;
				PlayState.isShitpostMode = false;
				PlayState.storyDifficulty = curDifficulty;
				
				PlayState.storyWeek = songs[curSelected].week;
				PlayState.autoMode = autoModeSelected;
				trace('CUR WEEK' + PlayState.storyWeek);
				trace('CURRENT SONG:' + poop.toUpperCase());
				FlxG.switchState(new ModifierState());
		}

		/*
		if (FlxG.keys.justPressed.I)
			changeAlbum();
		*/
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 1)
			curDifficulty = 3;
		if (curDifficulty > 3)
			curDifficulty = 1;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 1:
				diffText.text = textObjects[2];
			case 2:
				diffText.text = textObjects[3];
			case 3:
				diffText.text = textObjects[4];
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
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end
		FlxG.sound.playMusic('assets/music/' + songs[curSelected].songName + "_Inst" + TitleState.soundExt, 0);
		for (i in 0...iconArray.length)
			{
				iconArray[i].alpha = 0.6;
			}
	
			iconArray[curSelected].alpha = 1;
	
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
class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
