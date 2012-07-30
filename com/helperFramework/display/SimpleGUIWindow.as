import com.greensock.TweenLite;
import com.helperFramework.events.MouseEvent;
import com.helperFramework.events.WindowWatcherEvent;
import com.helperFramework.utils.Relegate;
import com.helperFramework.utils.WindowWatcher;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.display.SimpleGUIWindow {
	
	private var _flash:MovieClip;
	private var _window:MovieClip;
	private var _guiName:String;
	
	public function SimpleGUIWindow(swfRoot:MovieClip, guiName:String, windowClipName:String) {
		_flash = swfRoot;
		_guiName = guiName;
		
		_window = _flash[windowClipName];
		_window._alpha = 0;
		_window._visible = false;
		
		WindowWatcher.getInstance(_guiName).addEventListener(WindowWatcherEvent.CLOSE_WINDOW, Relegate.create(this, _onCloseWanted));
		WindowWatcher.getInstance(_guiName).addEventListener(WindowWatcherEvent.OPEN_WINDOW, Relegate.create(this, _onWindowOpen));
		WindowWatcher.getInstance(_guiName).addEventListener(WindowWatcherEvent.DIM_WINDOW, Relegate.create(this, _onWindowDim));
		WindowWatcher.getInstance(_guiName).addEventListener(WindowWatcherEvent.UNDIM_WINDOW, Relegate.create(this, _onWindowUndim));
	}
	
	private function _onWindowUndim():Void {
		TweenLite.to(_window.background, 0.3, { _alpha:100 } );
	}
	
	private function _onWindowDim():Void {
		TweenLite.to(_window.background, 0.3, { _alpha:40 } );
	}
	
	
	private function _onWindowOpen():Void {
		_window._y = 0;
		_window._visible = true;
		_window._x = (Stage.width - WindowWatcher.getInstance(_guiName).windowWidth) * 0.5;
		
		TweenLite.to(_window, 0.3, { _alpha:100, _y:25 } );
	}
	
	
	private function _onCloseWanted(evt:WindowWatcherEvent):Void {
		_hideWindow();
	}
	
	private function _hideWindow():Void {
		TweenLite.to(_window, 0.3, { _xscale:90, _yscale:90, _alpha:0, _x:_window._x + (WindowWatcher.getInstance(_guiName).windowWidth * 0.05), _y:_window._y + (WindowWatcher.getInstance(_guiName).windowHeight * 0.05), onComplete:Relegate.create(this, _onCloseEnd) } );
	}
	
	private function _onCloseEnd():Void {
		Selection.setFocus(null);
		WindowWatcher.getInstance(_guiName).externalCloseEnd();
		WindowWatcher.getInstance(_guiName).removeAllEventListeners(WindowWatcherEvent.CLOSE_WINDOW);
		WindowWatcher.getInstance(_guiName).removeAllEventListeners(WindowWatcherEvent.OPEN_WINDOW);
		WindowWatcher.getInstance(_guiName).removeAllEventListeners(WindowWatcherEvent.DIM_WINDOW);
		WindowWatcher.getInstance(_guiName).removeAllEventListeners(WindowWatcherEvent.UNDIM_WINDOW);
	}
	
}