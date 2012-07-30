/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.events.BasicEvent {
	
	private var _type:String;
	
	public function BasicEvent(type:String) {
		_type = type;
	}
	public function get type():String { return _type; }
	
}