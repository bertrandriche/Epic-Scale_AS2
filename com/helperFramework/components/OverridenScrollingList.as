import gfx.controls.ScrollingList;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.OverridenScrollingList extends ScrollingList {
	
	public function OverridenScrollingList() {
		super();
	}
	
	public function removeWheelListeners():Void {
		for (var i:Number = 0; i < renderers.length; i++) {
			var clip:MovieClip = renderers[i];
			Mouse.removeListener(clip);
			clip.scrollWheel = null;
			delete clip.scrollWheel;
		}
	}
	
	public function get items():Array {
		return renderers;
	}
	
}