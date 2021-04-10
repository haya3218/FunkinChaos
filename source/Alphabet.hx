package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;

/**
 * Loosley based on FlxTypeText lolol
 */
class Alphabet extends FlxSpriteGroup
{
	public var delay:Float = 0.05;
	public var paused:Bool = false;

	// for menu shit
	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;
	public var isOptionItem:Bool = false;

	public var text:String = "";

	var _finalText:String = "";
	var _curText:String = "";

	public var widthOfWords:Float = FlxG.width;

	var yMulti:Float = 1;

	// custom shit
	// amp, backslash, question mark, apostrophy, comma, angry faic, period
	var lastSprite:AlphaCharacter;
	var lastWasEscape:Bool = false;
	var xPosResetted:Bool = false;
	var lastWasSpace:Bool = false;

	var splitWords:Array<String> = [];

	var isBold:Bool = false;
	var isPixelated:Bool = false;

	public function new(x:Float, y:Float, text:String = "", ?bold:Bool = false, typed:Bool = false, pixelated:Bool = false)
	{
		super(x, y);

		_finalText = text;
		this.text = text;
		isBold = bold;
		isPixelated = pixelated;

		if (text != "")
		{
			if (typed)
			{
				startTypedText();
			}
			else
			{
				addText();
			}
		}
	}

	public function addText()
	{
		doSplitWords();

		var xPos:Float = 0;
		var isComment:Bool = false;
		for (character in splitWords)
		{
			// if (character.fastCodeAt() == " ")
			// {
			// }
			var dummyCharacter = character;
			if (dummyCharacter == " " || character == "-")
			{
				lastWasSpace = true;
			}
			if (character == " " || character == "-")
			{
				lastWasSpace = true;
			}
			if (dummyCharacter == "\\" && !lastWasEscape) {
				lastWasEscape = true;
				continue;
			}
			if (lastWasEscape) {
				switch (dummyCharacter) {
					case "\\":
						// do nothing
					case "v":
						dummyCharacter = "da";
					case ">":
						dummyCharacter = "ra";
					case "<":
						dummyCharacter = "la";
					case "^":
						dummyCharacter = "ua";
					case "h":
						dummyCharacter = "heart";
				}
				lastWasEscape = false;
			}

			if ((AlphaCharacter.alphabet.indexOf(dummyCharacter.toLowerCase()) != -1 || AlphaCharacter.numbers.indexOf(dummyCharacter) != -1 || StringTools.contains(AlphaCharacter.symbols,dummyCharacter)) && (dummyCharacter != "-"))
				// if (AlphaCharacter.alphabet.contains(character.toLowerCase()))
			{
				if (lastSprite != null)
				{
					xPos = lastSprite.x + lastSprite.width;
				}

				if (lastWasSpace)
				{
					xPos += 40;
					lastWasSpace = false;
				}

				// var letter:AlphaCharacter = new AlphaCharacter(30 * loopNum, 0);
				var letter:AlphaCharacter = new AlphaCharacter(xPos, 0, isPixelated);

				if (isBold)
					letter.createBold(dummyCharacter);
				else
				{
					letter.createLetter(dummyCharacter);
				}

				add(letter);

				lastSprite = letter;
			}

			// loopNum += 1;
		}
	}

	function doSplitWords():Void
	{
		splitWords = _finalText.split("");
	}

	public var personTalking:String = 'gf';

	public function startTypedText():Void
	{
		_finalText = text;
		doSplitWords();

		// trace(arrayShit);

		var loopNum:Int = 0;

		var xPos:Float = 0;
		var curRow:Int = 0;

		new FlxTimer().start(0.05, function(tmr:FlxTimer)
		{
			// trace(_finalText.fastCodeAt(loopNum) + " " + _finalText.charAt(loopNum));
			if (_finalText.fastCodeAt(loopNum) == "\n".code)
			{
				yMulti += 1;
				xPosResetted = true;
				xPos = 0;
				curRow += 1;
			}

			if (splitWords[loopNum] == " ")
			{
				lastWasSpace = true;
			}

			#if (haxe >= "4.0.0")
			var isNumber:Bool = AlphaCharacter.numbers.contains(splitWords[loopNum]);
			var isSymbol:Bool = AlphaCharacter.symbols.contains(splitWords[loopNum]);
			#else
			var isNumber:Bool = AlphaCharacter.numbers.indexOf(splitWords[loopNum]) != -1;
			var isSymbol:Bool = AlphaCharacter.symbols.indexOf(splitWords[loopNum]) != -1;
			#end

			if (AlphaCharacter.alphabet.indexOf(splitWords[loopNum].toLowerCase()) != -1 || isNumber || isSymbol)
				// if (AlphaCharacter.alphabet.contains(splitWords[loopNum].toLowerCase()) || isNumber || isSymbol)

			{
				if (lastSprite != null && !xPosResetted)
				{
					lastSprite.updateHitbox();
					xPos += lastSprite.width + 3;
					// if (isBold)
					// xPos -= 80;
				}
				else
				{
					xPosResetted = false;
				}

				if (lastWasSpace)
				{
					xPos += 20;
					lastWasSpace = false;
				}
				// trace(_finalText.fastCodeAt(loopNum) + " " + _finalText.charAt(loopNum));

				// var letter:AlphaCharacter = new AlphaCharacter(30 * loopNum, 0);
				var letter:AlphaCharacter = new AlphaCharacter(xPos, 55 * yMulti);
				letter.row = curRow;
				if (isBold)
				{
					letter.createBold(splitWords[loopNum]);
				}
				else
				{
					if (isNumber)
					{
						letter.createNumber(splitWords[loopNum]);
					}
					else if (isSymbol)
					{
						letter.createSymbol(splitWords[loopNum]);
					}
					else
					{
						letter.createLetter(splitWords[loopNum]);
					}

					letter.x += 90;
				}

				if (FlxG.random.bool(40))
				{
					var daSound:String = "GF_";
					FlxG.sound.play(Paths.soundRandom(daSound, 1, 4));
				}

				add(letter);

				lastSprite = letter;
			}

			loopNum += 1;

			tmr.time = FlxG.random.float(0.04, 0.09);
		}, splitWords.length);
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16 * (60.0 / MusicBeatState.funkyFramerate));
			x = FlxMath.lerp(x, (targetY * 20) + 90, 0.16 * (60.0 / MusicBeatState.funkyFramerate));
			x = FlxMath.lerp(x, (targetY * 20) + 90, 0.16 * (60.0 / MusicBeatState.funkyFramerate));
		}

		if (isOptionItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16 * (60.0 / MusicBeatState.funkyFramerate));
		}

		super.update(elapsed);
	}
}

class AlphaCharacter extends FlxSprite
{
	public static var alphabet:String = "abcdefghijklmnopqrstuvwxyz";

	public static var numbers:String = "1234567890";

	public static var symbols:String = ".,'!/?\\-+_#$%&()*:;<=>@[]^|~\"daralauaheart";

	public var row:Int = 0;

	public function new(x:Float, y:Float, pixelated:Bool = false)
	{
		super(x, y);
		var tex = FlxAtlasFrames.fromSparrow('assetss/images/alphabet.png', 'assetss/images/alphabet.xml');

		if (pixelated)
			tex = FlxAtlasFrames.fromSparrow('assetss/images/weeb/pixelUI/alphabet.png', 'assetss/images/weeb/pixelUI/alphabet.xml');
		else 
			tex = FlxAtlasFrames.fromSparrow('assetss/images/alphabet.png', 'assetss/images/alphabet.xml');
		frames = tex;

		antialiasing = true;
	}

	public function createBold(letter:String)
	{
		var animName:String = "";
		switch (letter)
		{
			case '.':
				animName = "period bold";
				y += 50;
			case "'":
				animName = "apostraphie bold";
				y -= 0;
			case "?":
				animName = "question mark bold";
			case "!":
				animName = "exclamation point bold";
			case ",":
				animName = "comma bold";
			case "\\":
				animName = "bs bold";
			case "/":
				animName = "fs bold";
			case "da":
				animName = "down arrow bold";
			case "ua":
				animName = "up arrow bold";
			case "la":
				animName = "left arrow bold";
			case "heart":
				animName = "heart bold";
			case "ra":
				animName = "right arrow bold";
			case "\"":
				animName = "quote";
			default:
				animName = letter.toUpperCase() + " bold";
		}
		animation.addByPrefix(letter, animName, 24);
		animation.play(letter);
		updateHitbox();
	}

	public function createLetter(letter:String):Void
	{
		var letterCase:String = "lowercase";
		if (letter.toLowerCase() != letter)
		{
			letterCase = 'capital';
		}

		animation.addByPrefix(letter, letter + " " + letterCase, 24);
		animation.play(letter);
		updateHitbox();

		FlxG.log.add('the row' + row);

		y = (110 - height);
		y += row * 60;
	}

	public function createNumber(letter:String):Void
	{
		animation.addByPrefix(letter, letter, 24);
		animation.play(letter);

		updateHitbox();
	}

	public function createSymbol(letter:String)
	{
		switch (letter)
		{
			case '.':
				animation.addByPrefix(letter, 'period', 24);
				animation.play(letter);
				y += 50;
			case "'":
				animation.addByPrefix(letter, 'apostraphie', 24);
				animation.play(letter);
				y -= 0;
			case "?":
				animation.addByPrefix(letter, 'question mark', 24);
				animation.play(letter);
			case "!":
				animation.addByPrefix(letter, 'exclamation point', 24);
				animation.play(letter);
		}

		updateHitbox();
	}
}