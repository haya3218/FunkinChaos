package;
import lime.utils.Assets;
import haxe.Json;
#if sys
import sys.io.File;
#end
typedef TOptions = {
    var fpsLimit:Bool;
    var p2noteStrums:Bool;
    var momentCutscene:Bool;
    var momentEffect:Bool;
    var boldText:Bool;
    var cinematicMode:Bool;
    var modifierMenu:Bool;
    var bSidesIGuess:Bool;
    var allowNoteAutosaving:Bool;
    var preferredSave:Int;
}
class OptionsHandler {
    public static var options(get, set):TOptions;
    static function get_options() {
        // update the file
        return Json.parse(Assets.getText('assetss/data/options.json'));
    }
    static function set_options(opt:TOptions) {
        File.saveContent('assetss/data/options.json', CoolUtil.coolStringifyJson(opt));
        return opt;
    }
}