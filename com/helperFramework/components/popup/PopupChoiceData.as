import gfx.controls.Button;
/**
 * Used with the Popup class. Stores the data of a choice.
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.popup.PopupChoiceData {
	
	private var _id:Number;
	private var _button:Button;
	private var _callback:Function;
	private var _type:String;
	
	public function PopupChoiceData(id:Number, type:String, button:Button, callBack:Function) {
		_id = id;
		_type = type;
		_button = button;
		_callback = callBack;
	}
	
	public function get id():Number { return _id; }
	public function get button():Button { return _button; }
	public function get callback():Function { return _callback; }
	public function get type():String { return _type; }
	
}