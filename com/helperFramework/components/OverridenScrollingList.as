/**
 * Simple ScrollingList component extending the base CLIK component included in Scaleform 3.3.
 * Additions :
	 * removeWheelListeners : function to remove default mouse wheel listeners that are added to every and single item added to the list, making the list totally unable to be used with user-custom built behaviors.
	 * getter items : simple fonction to gain direct access to the items displayed in the list.
 * @author bertrandr@funcom.com
 */

import gfx.controls.ScrollingList;

class com.helperFramework.components.OverridenScrollingList extends ScrollingList {
	
	public function OverridenScrollingList() {
		super();
	}
	
	/**
	 * Removes all the mouse wheel listeners added to every item of the list. Used to make the user-custom built behaviors works and not be overwritten by that default and useless behavior.
	 */
	public function removeWheelListeners():Void {
		for (var i:Number = 0; i < renderers.length; i++) {
			var clip:MovieClip = renderers[i];
			Mouse.removeListener(clip);
			clip.scrollWheel = null;
			delete clip.scrollWheel;
		}
	}
	
	/**
	 * Returns an Array of the items of the list.
	 */
	public function get items():Array {
		return renderers;
	}
	
}