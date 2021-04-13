package unsys.save;

import haxe.Json;
import haxe.io.Bytes;

#if openfl
import openfl.utils.ByteArray;
import openfl.events.MouseEvent;
import openfl.net.FileReference;
import openfl.Lib;
#elseif flash
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.Lib;
#elseif js
import js.Browser;
import js.html.Blob;
import js.html.URL;
import js.html.AnchorElement;
#end

/**
 * Save resources helper function
 */
class FileJS
{
  // Default filename
  public static inline var DEFAULT_BYTES_NAME = 'file.bin';
  public static inline var DEFAULT_STRING_NAME = 'file.txt';
  public static inline var DEFAULT_JSON_NAME = 'file.json';
  
  // Default mime-type
  public static inline var DEFAULT_BYTES_TYPE = 'application/octet-stream';
  public static inline var DEFAULT_STRING_TYPE = 'text/plain';
  public static inline var DEFAULT_JSON_TYPE = 'application/json';
  
  // No need to instantiate
  private function new() {}

  // Write Bytes
  public static inline function writeBytes(bytes:Bytes, path:String) {
    #if sys
    sys.io.File.saveBytes(path, bytes);
    #else
    throw 'Not implemented';
    #end
  }

  // Save Bytes
  private static function _saveBytes(bytes:Bytes, name:String = DEFAULT_BYTES_NAME, type:String = DEFAULT_BYTES_TYPE)
  {
    // Save File per target
    trace("");
    
    // - OpenFL / Flash
    #if (openfl || flash)
    var fileRef:FileReference = new FileReference();
    #if openfl
    fileRef.save(ByteArrayData.fromBytes(bytes), name);
    #else
    fileRef.save(bytes.getData(), name);
    #end
    
    // - JS
    #elseif js
    var a = Browser.document.createAnchorElement();
    var blob = new Blob([bytes.getData()], {type: type});
    var url = URL.createObjectURL(blob);

    a.href = url;
    a.download = name;
    Browser.document.body.appendChild(a);

    a.click();

    Browser.window.setTimeout(function()
    {
      Browser.document.body.removeChild(a);
      URL.revokeObjectURL(url);
    }, 0);
    #end
    
    trace("Saved");
  }
  
  // Add click to save functionality
  private static function _addClick(handler:Void->Void)
  {
    // Save File per target
    #if (openfl || flash)
    var eventHandler:MouseEvent->Void = null;
    eventHandler = function(e)
    {
      Lib.current.stage.removeEventListener(MouseEvent.CLICK, eventHandler);
      
      if ( handler != null ) handler();
    };
    Lib.current.stage.addEventListener(MouseEvent.CLICK, eventHandler);
    
    #elseif js
    Browser.window.onclick = function()
    {
      // TODO: Only allow one click event, so could be in conflict with others...
      Browser.window.onclick = null;

      if ( handler != null ) handler();
    };
    #end
    
    trace("Click to save");
  }
  
  // Save a Bytes file by user using File Dialog
  public static function saveBytes(bytes:Bytes, name:String = DEFAULT_BYTES_NAME, type:String = DEFAULT_BYTES_TYPE)
  {
    _saveBytes(bytes, name, type);
  }

  // Save a Text file by user using File Dialog
  public static function saveString(str:String, name:String = DEFAULT_STRING_NAME, type:String = DEFAULT_STRING_TYPE)
  {
    _saveBytes(Bytes.ofString(str), name, type);
  }

  // Save a Json file by user using File Dialog
  public static function saveJson(json:Dynamic, name:String = DEFAULT_JSON_NAME, type:String = DEFAULT_JSON_TYPE, prettify:Bool = false)
  {
    if (prettify)
        _saveBytes( Bytes.ofString(Json.stringify(json, null, '    ')), name, type);
    else
        _saveBytes( Bytes.ofString(Json.stringify(json)), name, type);
  }
  
  // Save a Bytes file after a Click by user using File Dialog
  public static function saveClickBytes(bytes:Bytes, name:String = DEFAULT_BYTES_NAME, type:String = DEFAULT_BYTES_TYPE)
  {
    _addClick(function()
    {
      saveBytes(bytes, name, type);
    });
  }
  
  // Save a Text file after a Click by user using File Dialog
  public static function saveClickString(str:String, name:String = DEFAULT_STRING_NAME, type:String = DEFAULT_STRING_TYPE)
  {
    _addClick(function()
    {
      saveString(str, name, type);
    });
  }
  
  // Save a Json file after a Click by user using File Dialog
  public static function saveClickJson(json:Dynamic, name:String = DEFAULT_JSON_NAME, type:String = DEFAULT_JSON_TYPE)
  {
    _addClick(function()
    {
      saveJson(json, name, type, false);
    });
  }
}