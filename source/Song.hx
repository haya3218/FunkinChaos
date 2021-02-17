package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
#if sys
import sys.io.File;
import lime.system.System;
import haxe.io.Path;
#end
using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Int;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gf:String;
	var stage:String;
	var validScore:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Int;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gf:String = 'gf';

	public var stage:String = 'stage';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		#if sys
		var rawJson = File.getContent(Path.normalize(System.applicationDirectory+"/assets/data/"+folder.toLowerCase()+"/"+jsonInput.toLowerCase()+'.json')).trim();
		#else
		var rawJson = Assets.getText('assets/data/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase() + '.json').trim();
		#end
		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}
		var parsedJson = parseJSONshit(rawJson);
		// CUSTOM STAGES SHIT
		if (parsedJson.stage == null) {
			if (parsedJson.song.toLowerCase() == 'spookeez'|| parsedJson.song.toLowerCase() == 'monster' || parsedJson.song.toLowerCase() == 'south') {
				parsedJson.stage = 'spooky';
			} else if (parsedJson.song.toLowerCase() == 'pico' || parsedJson.song.toLowerCase() == 'philly' || parsedJson.song.toLowerCase() == 'blammed') {
				parsedJson.stage = 'philly';
			} else if (parsedJson.song.toLowerCase() == 'milf' || parsedJson.song.toLowerCase() == 'high' || parsedJson.song.toLowerCase() == 'satin-panties') {
				parsedJson.stage = 'limo';
			} else if (parsedJson.song.toLowerCase() == 'mtc') {
				parsedJson.stage = 'mtc';
			} else if (parsedJson.song.toLowerCase() == 'cocoa' || parsedJson.song.toLowerCase() == 'eggnog') {
				parsedJson.stage = 'mall';
			} else if (parsedJson.song.toLowerCase() == 'winter-horrorland') {
				parsedJson.stage = 'mallEvil';
			} else if (parsedJson.song.toLowerCase() == 'senpai' || parsedJson.song.toLowerCase() == 'roses') {
				parsedJson.stage = 'school';
			} else if (parsedJson.song.toLowerCase() == 'thorns') {
				parsedJson.stage = 'schoolEvil';
			} else if (parsedJson.song.toLowerCase() == 'friday-night' || parsedJson.song.toLowerCase() == 'judgement' || parsedJson.song.toLowerCase() == 'machine-gun-kiss') {
				parsedJson.stage = 'yakuza';
			} else if (parsedJson.song.toLowerCase() == 'luci-moment' || parsedJson.song.toLowerCase() == 'disappear'){
				parsedJson.stage = 'miku';
			} else if (parsedJson.song.toLowerCase() == 'mc-mental-at-his-best'){
				parsedJson.stage = 'trick';
			} else {
				parsedJson.stage = 'stage';
			}
		}
		if (parsedJson.gf == null) {
			switch (parsedJson.stage.toLowerCase()) {
				case 'limo' | 'mtc':
					parsedJson.gf = 'gf-car';
				case 'mall':
					parsedJson.gf = 'gf-christmas';
				case 'mallEvil':
					parsedJson.gf = 'gf-christmas';
				case 'school':
					parsedJson.gf = 'gf-pixel';
				case 'schoolEvil':
					parsedJson.gf = 'gf-pixel';
				default:
					parsedJson.gf = 'gf';
			}
		}
		return parsedJson;
	}
	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
