/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.events.StatusEvent {
	
	static public var READY:String = "ready";
	static public var COMPLETE:String = "complete";
	static public var CLOSE:String = "close";
	static public var CHANGE:String = "change";
	static public var ERROR:String = "error";
	
	private var _type:String;
	
	public function StatusEvent(type:String) {
		_type = type;
	}
	public function get type():String { return _type; }
	
}