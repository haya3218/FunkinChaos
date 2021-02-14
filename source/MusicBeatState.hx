package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import haxe.Json;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;
	public static var funkyFramerate:Int = 420;
	public static var vocalVolume:Float = 0;
	public static var musicVolume:Float = 0;
	public static var sfxVolume:Float = 0;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		var optionsJson = Json.parse(Assets.getText('assets/data/options.json'));
		vocalVolume = optionsJson.vocalShiz;
		musicVolume = optionsJson.musicVolume;
		if (transIn != null)
			trace('reg ' + transIn.region);

		#if (!web)
		TitleState.soundExt = '.ogg';
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		// Needs to be ROUNED, rather than ceil or floor
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
			lastChange = Conductor.bpmChangeMap[i];
		}
	
	curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
