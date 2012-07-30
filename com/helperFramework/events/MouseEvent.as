/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.events.MouseEvent {
	
	static public var CLICK:String = "click";
	static public var MOUSE_WHEEL:String = "mouseWheel";
	
	private var _type:String;
	
	public function MouseEvent(type:String) {
		_type = type;
	}
	
}