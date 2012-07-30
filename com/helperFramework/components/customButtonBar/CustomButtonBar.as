import gfx.controls.Button;
import com.helperFramework.components.customButtonBar.CustomButtonBarEntry
import com.helperFramework.utils.Relegate;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.customButtonBar.CustomButtonBar {
	
	private var _container:MovieClip;
	
	private var _buttonsUID:Number;
	private var _buttons:Array/*CustomButtonBarEntry*/;
	private var _numButtons:Number;
	private var _libraryLinkage:String;
	
	/**
	 * Creates an easily customizable button bar.
	 * @param	container				MovieClip	> the container in which the added buttons will be created.
	 * @param	libraryLinkage			String		> the library linkage name of the symbol to use for the buttons
	 */
	public function CustomButtonBar(container:MovieClip, libraryLinkage:String) {
		_container = container;
		_libraryLinkage = libraryLinkage;
		if (_libraryLinkage == "" || _libraryLinkage == null || _libraryLinkage == undefined) _libraryLinkage = "Button";
		
		_buttons = [];
		_numButtons = 0;
		_buttonsUID = -1;
	}
	
	/**
	 * Adds a new button to the bar.
	 * @param	buttonLabel			String		> the label to display of the button
	 * @param	buttonCallBack			Function	> the callback function to call when the button is clicked
	 * @param	xPos					Number		> the X position of the button in pixels
	 * @param	yPos					Number		> the Y position of the button in pixels
	 * @param	width					Number		> the width of the button. I do not know the unit of this thing, because the Scaleform framework is totally obscure and inconsistent in terms of initialization & values of things it uses. Its a total crap (and combining that with AS2 is the fooliest things ever made on Earth).
	 * @return				Number					> the unique ID of the button for a later user
	 */
	public function addButton(buttonLabel:String, buttonCallBack:Function, xPos:Number, yPos:Number, width:Number):Number {
		
		_buttonsUID++;
		
		var newButton:Button = Button(_container.attachMovie(_libraryLinkage, "button" + _buttonsUID, _container.getNextHighestDepth()));
		
		_buttons[_numButtons] = new CustomButtonBarEntry(_buttonsUID, newButton);
		_numButtons++;
		newButton._x = xPos;
		newButton._y = yPos;
		newButton.width = width;
		newButton.label = buttonLabel;
		
		newButton.addEventListener("click", buttonCallBack);
		newButton.addEventListener("releaseOutside", Relegate.create(this, _onReleaseOutside, newButton));
		
		return _buttonsUID;
		
	}
	
	private function _onReleaseOutside(targetButton:Button):Void {
		Selection.setFocus(null);
	}
	
	
	/**
	 * Retrieves a specific registered button
	 * @param	buttonUID				Number		> the unique ID of the button
	 * @return
	 */
	public function getButton(buttonUID:Number):Button {
		for (var i:Number = 0; i < _numButtons; i++) {
			if (_buttons[i].uid == buttonUID) return _buttons[i].button;
		}
		return null;
	}
	
	/**
	 * Removes all the buttons of the bar
	 */
	public function clear():Void {
		var oldButton:Button;
		
		for (var i:Number = 0; i < _numButtons; i++) {
			oldButton = _buttons[0].button;
			oldButton.removeAllEventListeners("click");
			oldButton.removeMovieClip();
			_buttons.splice(0, 1);
			oldButton = null;
		}
		_buttons = [];
		_numButtons = 0;
	}
	
	public function get container():MovieClip { return _container; }
	
}