import gfx.controls.Button;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.customButtonBar.CustomButtonBarEntry {
	
	private var _uid:Number;
	private var _button:Button;
	
	public function CustomButtonBarEntry(buttonUID:Number, button:Button) {
		_uid = buttonUID;
		_button = button;
	}
	public function get uid():Number { return _uid; }
	public function get button():Button { return _button; }
	
}