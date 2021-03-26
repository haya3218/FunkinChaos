import flixel.FlxG;

/**
* A second class for saves.
* Pros: Unlike OptionsHandler however, its simple to add and use lol!
* Cons: They can't be edited outside of the game :sadman:
*/
class Saves
{
    public static function initSave()
    {
		if (FlxG.save.data.etternaMode == null)
            FlxG.save.data.etternaMode = false;

        if (FlxG.save.data.songPosition == null)
            FlxG.save.data.songPosition = false;

        if (FlxG.save.data.itgPopupScore == null)
            FlxG.save.data.itgPopupScore = false;
    }
}