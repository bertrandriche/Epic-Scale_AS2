import com.helperFramework.utils.ArrayUtils;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.utils.Logger {
	
	public static var INFO:String = "info";
	public static var DEBUG:String = "debug";
	public static var WARN:String = "warn";
	public static var ERROR:String = "error";
	public static var FATAL:String = "fatal";
	
	private static var MAX_LEVEL_LENGTH:Number = 5;
	
	public static var _levels:Array = [[INFO, "---***INFO***---"], [DEBUG, "======***DEBUG***======"], [WARN, ">>>>>>>>>>>>>>>>>>>***WARN***<<<<<<<<<<<<<<<<<<"], [ERROR, ["**********************ERROR**********************", "*************************************************"]], [FATAL, ["===================================================", "=========================***FATAL***===========================", "==================================================="]]];
	public static var _numLevels:Number = _levels.length;
	
	
	public function Logger() {}
	
	public static function trace(value:Object):Void {
		var level:String = INFO;
		
		if (arguments.length < 2) {
			_outputLevel(level);
			trace(value);
		} else {
			var outputs:Array = arguments;
			
			var total:Number = outputs.length;
			for (var i:Number = 0; i < total; i++) {
				if (typeof(outputs[i]) == "string" && outputs[i].length <= MAX_LEVEL_LENGTH) {
					if (ArrayUtils.isInArray(outputs[i], _levels, true)) {
						level = outputs[i];
						outputs.splice(i, 1);
						break;
					}
				}
			}
			
			_outputLevel(level);
			_separateTraces(outputs);
		}
		
		_outputLevel(level);
	}
	
	static public function info():Void { _internalTrace(arguments, INFO); }
	static public function debug():Void { _internalTrace(arguments, DEBUG); }
	static public function warn():Void { _internalTrace(arguments, WARN); }
	static public function error():Void { _internalTrace(arguments, ERROR); }
	static public function fatal():Void { _internalTrace(arguments, FATAL); }
	
	static public function splitLog(item:Object, autoOutput:Boolean):String {
		if (autoOutput == null || autoOutput == undefined) autoOutput = true;
		var result:String = "";
		
		for (var name:String in item) {
			result += name + " > " + item[name] + " | ";
		}
		
		if (autoOutput) trace(result);
		
		return result;
	}
	
	static private function _internalTrace(outputs:Array, level:String):Void {
		_outputLevel(level);
		_separateTraces(outputs);
		_outputLevel(level);
	}
	
	static private function _outputLevel(level:String):Void {
		
		var indicator:Array = _getLevelIndicator(level);
		if (indicator instanceof Array) {
			//var result:String = "";
			var total:Number = indicator.length;
			for (var i:Number = 0; i < total; i++) {
				//result += indicator[i];
				//if (i < total - 1) result += "\n";
				trace(indicator[i]);
			}
			//trace(result);
		} else trace(indicator);
		
	}
	
	static private function _separateTraces(outputs:Array):Void {
		//var result:String = "";
		
		var outputsNum:Number = outputs.length;
		for (var i:Number = 0; i < outputsNum; i++) {
			//result += outputs[i];
			//if (i < outputsNum - 1) result += "\n";
			trace(outputs[i]);
		}
		
		//trace(result);
	}
	
	static private function _getLevelIndicator(level:String):Array {
		var indicator:Array;
		for (var i:Number = 0; i < _numLevels; i++) {
			if (_levels[i][0] == level) {
				if ( _levels[i][1].length < 2) indicator = [ _levels[i][1]];
				else indicator = _levels[i][1];
				break;
			}
		}
		return indicator;
	}
	
}