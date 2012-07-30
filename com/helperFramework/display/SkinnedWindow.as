import flash.geom.ColorTransform;
import com.helperFramework.utils.Logger;
import com.GameInterface.Utils;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.display.SkinnedWindow {
	
	private var _skin:MovieClip;
	private var _closeButton:MovieClip;
	
	private var htmlColor:Function = Utils.ParseHTMLColor;
	
	public function SkinnedWindow(skin:MovieClip, title:String) {
		_skin = skin;
		
		//disabling tab navigation
		_root.tabChildren = false;
		_closeButton = _skin._parent["closeBtn"];
		
		if (!title || title == undefined || title == "") return;
		_skin._parent.title = title;
		
	}
	
	
	public function clearSelection():Void {
		Selection.setFocus(null);
	}
	
}