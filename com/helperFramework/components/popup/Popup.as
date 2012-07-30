import com.greensock.TweenLite;
import gfx.controls.Button;
import gfx.core.UIComponent;
import gfx.events.EventDispatcher;
import gfx.managers.InputDelegate;
import gfx.ui.InputDetails;
import com.helperFramework.components.popup.PopupChoiceData
import com.helperFramework.events.StatusEvent;
import com.helperFramework.utils.Logger;
import com.helperFramework.utils.Relegate;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.popup.Popup extends EventDispatcher {
	
	public static var CHOICE_OK:String = "OK";
	public static var CHOICE_CANCEL:String = "Cancel";
	
	public static var CONTENT_TYPE_TEXT:String = "text";
	public static var CONTENT_TYPE_MOVIECLIP:String = "movieClip";
	
	
	private var BUTTONS_HEIGHT:Number = 50;
	
	private var _totalWidth:Number;
	private var _totalHeight:Number;
	
	private var _popup:MovieClip;
	private var _contentContainer:MovieClip;
	private var _bg:MovieClip;
	private var _content:MovieClip;
	private var _choicesContainer:MovieClip;
	
	private var _choices:Array/*PopupChoiceData*/;
	private var _uniqueChoiceID:Number = 0;
	private var _popupName:String;
	private var _container:MovieClip;
	private var _isModal:Boolean;
	private var _modalBlocker:MovieClip;
	private var _closeOnClickOutside:Boolean;
	
	
	public function Popup(container:MovieClip, width:Number, height:Number, isModal:Boolean, screenWidth:Number, screenHeight:Number, closeOnClickOutside:Boolean) {
		_totalWidth = width;
		_totalHeight = height;
		_container = container;
		_isModal = isModal;
		if (closeOnClickOutside == null || closeOnClickOutside == undefined) closeOnClickOutside = false;
		_closeOnClickOutside = closeOnClickOutside;
		
		if (_isModal) {
			_modalBlocker = container.createEmptyMovieClip("modalBlocker", container.getNextHighestDepth());
			_modalBlocker.beginFill(0x000000, 100);
			_modalBlocker.moveTo(0, 0);
			_modalBlocker.lineTo(screenWidth, 0);
			_modalBlocker.lineTo(screenWidth, screenHeight);
			_modalBlocker.lineTo(0, screenHeight);
			_modalBlocker.endFill();
			_modalBlocker._alpha = 0;
			_modalBlocker._visible = false;
			
			_modalBlocker.onRelease = Relegate.create(this, _onBlockerClick);
		}
		
		_popup = container.createEmptyMovieClip("popup" + container.getNextHighestDepth(), container.getNextHighestDepth());
		_popup._visible = false;
		
		_bg = _popup.attachMovie("LibPopupBG", "bg", _popup.getNextHighestDepth());;
		
		_bg._width = _totalWidth;
		_bg._height = _totalHeight;
		
		_popup._x = - _totalWidth * 0.5;
		_popup._y = - _totalHeight * 0.5;
		
		_contentContainer = _popup.createEmptyMovieClip("content", _popup.getNextHighestDepth());
		
		_choicesContainer = _contentContainer.createEmptyMovieClip("choices", _contentContainer.getNextHighestDepth());
		
		_choices = [];
		_uniqueChoiceID = 0;
		
	}
	
	private function _onBlockerClick():Void {
		if (_closeOnClickOutside) {
			_internalHide();
		}
	}
	
	private function _internalHide():Void {
		hide();
		dispatchEvent(new StatusEvent(StatusEvent.CLOSE));
	}
	
	
	public function createContent(contentType:String, newContent:String):Void {
		if (_content != null) _content.removeMovieClip();
		
		if (contentType == CONTENT_TYPE_MOVIECLIP) {
			_content = _contentContainer.attachMovie(newContent, "content" + _contentContainer.getNextHighestDepth(), _contentContainer.getNextHighestDepth());
		} else if (contentType == CONTENT_TYPE_TEXT) {
			_content = _contentContainer.createEmptyMovieClip("content" + _contentContainer.getNextHighestDepth(), _contentContainer.getNextHighestDepth());
			var label:TextField = _content.createTextField("contentText", _content.getNextHighestDepth(), 0, 0, _totalWidth * 0.8, 20);
			/// TODO > use the right font, right color & size for the popup text size
			label.autoSize = "left";
			label.multiline = true;
			label.wordWrap = true;
			var tFormat:TextFormat = new TextFormat();
			tFormat.align = "center";
			tFormat.color = 0xFF7F00;
			tFormat.size = 20;
			tFormat.font = "_CompStandard";
			label.setNewTextFormat(tFormat);
			label.text = newContent;
			label._width = _totalWidth * 0.8;
		}
		
		_content._x = (_totalWidth - _content._width) * 0.5;
		_content._y = ((_totalHeight - BUTTONS_HEIGHT) - _content._height) * 0.5;
		
	}
	
	public function addChoice(choiceType:String, choiceLabel:String, result:Function, buttonWidth:Number):Void {
		var newChoice:Button = Button(_choicesContainer.attachMovie("Button", "choice" + _choices.length, _choicesContainer.getNextHighestDepth()));
		newChoice.width = buttonWidth;
		newChoice.label = choiceLabel;
		
		var data:PopupChoiceData = new PopupChoiceData(_uniqueChoiceID, choiceType, newChoice, result);
		
		newChoice.addEventListener("click", Relegate.create(this, _onChoiceClick));
		
		_choices[_choices.length] = data;
		_uniqueChoiceID++;
		
		_placeChoices();
	}
	
	public function clearChoices():Void {
		
		var oldChoice:Button;
		
		var total:Number = _choices.length;
		for (var i:Number = 0; i < total; i++) {
			oldChoice = _choices[0].button;
			oldChoice.removeAllEventListeners();
			oldChoice.removeMovieClip();
			_choices.splice(0, 1);
			oldChoice = null;
		}
		
		_choices = [];
	}
	
	public function show(popupName:String):Void {
		_popupName = popupName;
		
		_popup._visible = true;
		_popup._alpha = 0;
		_container._xscale = 90;
		_container._yscale = 90;
		
		TweenLite.to(_popup, 0.3, { _alpha:100 } );
		TweenLite.to(_container, 0.3, { _xscale:100, _yscale:100 } );
		
		if (_isModal) {
			_modalBlocker._x = -_container._x;
			_modalBlocker._y = -_container._y;
			
			_modalBlocker._visible = true;
			//TweenLite.to(_modalBlocker, 0.3, { _alpha:60 } );
		}
		
		Selection.setFocus(_content);
		InputDelegate.instance.addEventListener("input", Relegate.create(this, _handleInput));
	}
	
	public function hide():Void {
		TweenLite.to(_popup, 0.3, { _alpha:0 } );
		TweenLite.to(_container, 0.3, { _xscale:90, _yscale:90 } );
		
		if (_isModal) {
			_modalBlocker._visible = false;
			//TweenLite.to(_modalBlocker, 0.3, { _alpha:0, onComplete:Relegate.create(this, _hideModalBlocker) } );
		}
		
		Selection.setFocus(null);
		InputDelegate.instance.removeAllEventListeners("input");
	}
	
	private function _handleInput(event:Object):Void {
		var details:InputDetails = event.details;
		if (details.value == "keyUp") {
			var choice:PopupChoiceData;
			
			if (details.code == Key.ENTER) {
				choice = _getChoice(CHOICE_OK);
			} else if (details.code == Key.ESCAPE) {
				choice = _getChoice(CHOICE_CANCEL);
				if (choice == null) _internalHide();
			}
			if (choice != null) choice.callback.call();
		}
		
	}
	
	private function _getChoice():PopupChoiceData {
		var list:Array = arguments;
		
		var total:Number = list.length;
		var subTotal:Number = _choices.length;
		for (var i:Number = 0; i < total; i++) {
			for (var j:Number = 0; j < subTotal; j++) {
				if (_choices[j].type == list[i]) return _choices[j];
			}
		}
		return null;
	}
	
	
	private function _hideModalBlocker():Void {
		_modalBlocker._visible = false;
	}
	
	
	
	private function _onChoiceClick(infos:Object):Void {
		Selection.setFocus(null);
		
		var callBack:Function;
		
		var total:Number = _choices.length;
		for (var i:Number = 0; i < total; i++) {
			if (_choices[i].button == infos.target) {
				callBack = _choices[i].callback;
				break;
			}
		}
		
		callBack.call();
	}
	
	
	private function _placeChoices():Void {
		var offset:Number = 0;
		
		var total:Number = _choices.length;
		for (var i:Number = 0; i < total; i++) {
			//_choices[i].button._x = (i + 0.5) * (_totalWidth / (total + 1));
			_choices[i].button._x = offset;
			offset += _choices[i].button.width + 10;
			_choices[i].button._y = _totalHeight - _choices[i].button._height - 10;
		}
		
		_choicesContainer._x = (_totalWidth - (offset - 10)) * 0.5;
	}
	public function get popupName():String { return _popupName; }	
	
}