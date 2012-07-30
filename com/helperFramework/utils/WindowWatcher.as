import gfx.events.EventDispatcher;
import com.helperFramework.events.WindowWatcherEvent;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.utils.WindowWatcher extends EventDispatcher {
	
	static private var _instances:Array/*WindowWatcher*/;
	static private var _numInstances:Number = 0;
	
	private var _windowWidth:Number;
	private var _windowHeight:Number;
	private var _guiName:String;
	
	public function WindowWatcher(guiName:String) {
		_guiName = guiName;
	}
	
	public static function getInstance(guiName:String):WindowWatcher {
		if (guiName == "") return null;
		return _getInstance(guiName);
	}
	
	static private function _getInstance(guiName:String):WindowWatcher {
		var newInstance:WindowWatcher;
		
		if (_instances == null || _instances == undefined) {
			_instances = [];
			newInstance = _createInstance(guiName);
		} else {
			for (var i:Number = 0; i < _numInstances; i++) {
				if (_instances[i].guiName == guiName) {
					newInstance = _instances[i];
					break;
				}
			}
			if (newInstance == null || newInstance == undefined) newInstance = _createInstance(guiName);
		}
		
		return newInstance;
	}
	
	static private function _createInstance(guiName:String):WindowWatcher {
		var newInstance:WindowWatcher = new WindowWatcher(guiName);
		_instances[_numInstances] = newInstance;
		_numInstances++;
		
		return newInstance;
	}
	
	public function close():Void {
		dispatchEvent(new WindowWatcherEvent(WindowWatcherEvent.CLOSE_WINDOW, _guiName));
	}
	
	public function open():Void {
		dispatchEvent(new WindowWatcherEvent(WindowWatcherEvent.OPEN_WINDOW, _guiName));
	}
	
	public function toggleDim(dimmed:Boolean):Void {
		if (dimmed) dispatchEvent(new WindowWatcherEvent(WindowWatcherEvent.DIM_WINDOW, _guiName));
		else dispatchEvent(new WindowWatcherEvent(WindowWatcherEvent.UNDIM_WINDOW, _guiName));
	}
	
	public function setSizes(width:Number, height:Number):Void {
		_windowWidth = width;
		_windowHeight = height;
	}
	
	public function externalCloseStart():Void {
		dispatchEvent(new WindowWatcherEvent(WindowWatcherEvent.EXTERNAL_CLOSE_START, _guiName));
	}
	
	public function externalCloseEnd():Void {
		dispatchEvent(new WindowWatcherEvent(WindowWatcherEvent.EXTERNAL_CLOSE_END, _guiName));
	}
	
	public function get windowWidth():Number { return _windowWidth; }
	public function get windowHeight():Number { return _windowHeight; }
	public function get guiName():String { return _guiName; }
	
}
