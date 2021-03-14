package;
import lime.utils.Assets;
import haxe.Json;
#if sys
import sys.io.File;
#end
typedef TOptions = {
    var fpsLimit:Bool;
    var charSelBetter:Bool;
    var p2noteStrums:Bool;
<<<<<<< Updated upstream
    var downScroll:Bool;
=======
    var momentCutscene:Bool;
    var momentEffect:Bool;
    var boldText:Bool;
>>>>>>> Stashed changes
    var preferredSave:Int;
}
class OptionsHandler {
    public static var options(get, set):TOptions;
    static function get_options() {
        // update the file
        return Json.parse(Assets.getText('assets/data/options.json'));
    }
    static function set_options(opt:TOptions) {
        File.saveContent('assets/data/options.json', CoolUtil.coolStringifyJson(opt));
        return opt;
    }
}