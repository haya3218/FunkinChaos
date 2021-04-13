package;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

// classic
class LoadingState extends MusicBeatState
{
	inline static var MIN_TIME = 0.5;
	
	var target:FlxState;
	var stopMusic = false;
	
	var logoBl2:FlxSprite;
    var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft = false;
    var cachedMusic:Bool = false;
    var cachedVoices:Bool = false;
    var loaded:Bool = false;
	public static var songs:Array<String> = [];
	
	function new(target:FlxState, stopMusic:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}
	
	override function create()
	{
        if (!OptionsHandler.options.bSidesIGuess)
        {
            logoBl2 = new FlxSprite(-90, -60);
            logoBl2.frames = Paths.getSparrowAtlas('logoBumpin');
            logoBl2.antialiasing = true;
            logoBl2.animation.addByPrefix('bump', 'logo bumpin', 24);
            logoBl2.animation.play('bump');
            logoBl2.updateHitbox();
            logoBl2.color = FlxColor.BLACK;
    
            logoBl = new FlxSprite(-90, -60);
            logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
            logoBl.antialiasing = true;
            logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
            logoBl.animation.play('bump');
            logoBl.updateHitbox();
            // logoBl.screenCenter();
            // logoBl.color = FlxColor.BLACK;
    
            gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
            gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
            gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
            gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
            gfDance.antialiasing = true;
        }
		else
        {
            logoBl2 = new FlxSprite(-90, -60);
		    logoBl2.frames = Paths.getSparrowAtlas('logoBumpinB');
		    logoBl2.antialiasing = true;
		    logoBl2.animation.addByPrefix('bump', 'logo bumpin', 24);
		    logoBl2.animation.play('bump');
		    logoBl2.updateHitbox();
		    logoBl2.color = FlxColor.BLACK;

		    logoBl = new FlxSprite(-90, -60);
		    logoBl.frames = Paths.getSparrowAtlas('logoBumpinB');
		    logoBl.antialiasing = true;
		    logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		    logoBl.animation.play('bump');
		    logoBl.updateHitbox();
		    // logoBl.screenCenter();
		    // logoBl.color = FlxColor.BLACK;

		    gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		    gfDance.frames = Paths.getSparrowAtlas('gfDanceTitleB');
		    gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		    gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		    gfDance.antialiasing = true;
        }

        var shittyReminder:Alphabet = new Alphabet(0, 0, "LOADING.....", OptionsHandler.options.boldText, false);
		shittyReminder.color = FlxColor.WHITE;
		shittyReminder.screenCenter(XY);
        shittyReminder.y += 180;
		
		add(gfDance);
		add(logoBl2);
        add(logoBl);
		add(shittyReminder);

        FlxTween.tween(logoBl2, {y: logoBl.y + 10}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(logoBl, {y: logoBl.y + 10}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});
		
		// just loads the music n shit
		for (i in 0...songs.length)
		{
			FlxG.sound.cache('assetss/music/' + songs[i] + '_Inst.ogg');
			FlxG.log.add('CACHED ' + songs[i].toUpperCase() + ' INST!');
		}
        switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.cache('assetss/music/Lunchbox' + TitleState.soundExt);
			case 'roses':
				trace('MUSIC IS ALREADY PLAYING!');
			case 'thorns':
				FlxG.sound.cache('assetss/music/LunchboxScary' + TitleState.soundExt);
			case 'b-sides-senpai':
				FlxG.sound.cache('assetss/music/Lunchbox' + TitleState.soundExt);
			case 'b-sides-roses':
                trace('MUSIC IS ALREADY PLAYING!');
			case 'b-sides-thorns':
				FlxG.sound.cache('assetss/music/LunchboxScary' + TitleState.soundExt);
			case 'disappear':
				FlxG.sound.cache('assetss/music/LunchboxScary' + TitleState.soundExt);
			default:
				FlxG.sound.cache('assetss/music/title' + TitleState.soundExt);
		}
        cachedMusic = true;
		if (PlayState.SONG.needsVoices)
        {
            for (i in 0...songs.length)
			{
				FlxG.sound.cache('assetss/music/' + songs[i] + '_Voices.ogg');
				FlxG.log.add('CACHED ' + songs[i].toUpperCase() + ' VOCALS!');
			}
            cachedVoices = true;
        }
        
		var fadeTime = 0.25;
		
		if (cachedMusic && (cachedVoices && PlayState.SONG.needsVoices))
		{
			FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
			new FlxTimer().start(fadeTime + MIN_TIME, function(_){
				FlxG.switchState(target);
			});
		}
	}
	
	override function beatHit()
	{
		super.beatHit();
		
		logoBl.animation.play('bump');
        logoBl2.animation.play('bump');
		danceLeft = !danceLeft;
		
		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// nothing dumbass
	}
	
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		FlxG.switchState(new LoadingState(target, stopMusic));
	}

    function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		FlxG.switchState(target);
	}
    
    static function isSoundLoaded(path:String):Bool
    {
        return Assets.cache.hasSound(path);
    }
}
