import gfx.controls.ScrollBar;

/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.ExtendedScrollBar extends ScrollBar {
	
	public function ExtendedScrollBar() {
		super();
	}
	
	public function get dragging():Boolean {
		return isDragging;
	}
	
}