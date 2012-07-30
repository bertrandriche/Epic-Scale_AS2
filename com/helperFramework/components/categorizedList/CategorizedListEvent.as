import gfx.controls.ListItemRenderer;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.categorizedList.CategorizedListEvent {
	
	static public var SELECTION_CHANGE:String = "selectionChange";
	
	private var _type:String;
	private var _target:ListItemRenderer;
	
	public function CategorizedListEvent(type:String, target:ListItemRenderer) {
		_type = type;
		_target = target;
	}
	
	public function get target():ListItemRenderer { return _target; }
	public function get type():String { return _type; }
	
}