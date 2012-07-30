import gfx.controls.ListItemRenderer;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.categorizedList.CategorizedListItemRenderer extends ListItemRenderer {
	
	private var _id:Number;
	
	public function CategorizedListItemRenderer() {
		super();
	}
	
	public function get id():Number { return _id; }
	
}