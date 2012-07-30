/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.events.WindowWatcherEvent {
	
	static public var CLOSE_WINDOW:String = "closeWindow";
	static public var OPEN_WINDOW:String = "openWindow";
	static public var DIM_WINDOW:String = "dimWindow";
	static public var UNDIM_WINDOW:String = "undimWindow";
	static public var EXTERNAL_CLOSE_START:String = "externalCloseStart";
	static public var EXTERNAL_CLOSE_END:String = "externalCloseEnd";
	
	private var _type:String;
	private var _targetWindow:String;
	
	public function WindowWatcherEvent(type:String, windowName:String) {
		_type = type;
		_targetWindow = windowName;
	}
	
	public function get type():String { return _type; }
	public function get targetWindow():String { return _targetWindow; }
	
}
