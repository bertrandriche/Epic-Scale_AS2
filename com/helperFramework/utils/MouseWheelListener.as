/**
 * Places a listener on the mouse wheel, and fires the appropriate callback function whenever the mouse wheel is scrolled.
 * @author bertrandr@funcom.com
 */

import com.helperFramework.events.MouseEvent;
import com.helperFramework.utils.Relegate;
import gfx.events.EventDispatcher;

class com.helperFramework.utils.MouseWheelListener {
	
	private var _mouseWheelListener:Object;
	private var _onScrollCallback:Function;
	
	public function MouseWheelListener(callBack:Function) {
		_onScrollCallback = callBack;
		
		_mouseWheelListener = new Object();
		_mouseWheelListener.onMouseWheel = Relegate.create(this, _onMouseWheel); 
		Mouse.addListener(_mouseWheelListener);
	}
	
	private function _onMouseWheel(delta:Number):Void {
		_onScrollCallback(delta);
	}
	
	
	public function destroy():Void {
		Mouse.removeListener(_mouseWheelListener);
	}
	
}