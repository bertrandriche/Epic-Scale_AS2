/**
 * Simple Scrollbar component extending the base CLIK component included in Scaleform 3.3.
 * Additions :
	 * getter dragging : returns a Boolean indicating if the scrollbar is currently being dragged or not.
 * 
 * @author bertrandr@funcom.com
 */

import gfx.controls.ScrollBar;

class com.helperFramework.components.ExtendedScrollBar extends ScrollBar {
	

	public function ExtendedScrollBar() {
		super();
	}
	
	/**
	 * If the scrollbar is currently being dragged or not.
	 */
	public function get dragging():Boolean {
		return isDragging;
	}
	
}