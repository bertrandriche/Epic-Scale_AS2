import com.greensock.TweenLite;
import com.helperFramework.components.categorizedList.CategorizedListItemRenderer;
import com.helperFramework.events.StatusEvent;
import com.helperFramework.utils.Relegate;
import gfx.events.EventDispatcher;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.categorizedList.CategoryView extends EventDispatcher {
	
	public static var HEADER_FOLDING_INDICATOR_NAME:String = "arrow";
	public static var BG_NAME:String = "bg";
	public static var FOLDING_INDICATOR_RIGHT_OFFSET:Number = 10;
	
	public var smoothedAnimations:Boolean;
	
	private var _content:MovieClip;
	private var _header:MovieClip;
	
	private var _items:Array/*MovieClip*/;
	private var _numItems:Number;
	
	private var _afterHeaderPadding:Number;
	private var _verticalPadding:Number;
	private var _totalHeight:Number = 0;
	private var _internalHeight:Number = 0;
	private var _id:Number;
	
	private var _folded:Boolean = false;
	private var _itemsContainer:MovieClip;
	private var _headerContainer:MovieClip;
	
	
	public function CategoryView(id:Number, container:MovieClip, afterHeaderPadding:Number, verticalPadding:Number, animationsOn:Boolean) {
		_id = id;
		_content = container;
		_verticalPadding = verticalPadding;
		_afterHeaderPadding = afterHeaderPadding;
		smoothedAnimations = animationsOn;
		
		_itemsContainer = _content.createEmptyMovieClip("itemsContainer", _content.getNextHighestDepth());
		_headerContainer = _content.createEmptyMovieClip("headerContainer", _content.getNextHighestDepth());
		
		_numItems = 0;
		_items = [];
	}
	
	public function setHeader(header:MovieClip):Void {
		if (_header != null) _header.removeMovieClip();
		_header = header;
		
		_totalHeight = _header._height + _afterHeaderPadding;
		_internalHeight = _totalHeight;
		
		_header.onRelease = Relegate.create(this, _onHeaderClick);
		
	}
	
	private function _onHeaderClick():Void {
		if (_folded) unfold();
		else fold();
	}
	
	
	public function addItem(newItem:MovieClip):Void {
		_items[_numItems] = newItem;
		_numItems++;
		
		_placeItem(newItem);
	}
	
	private function _placeItem(newItem:MovieClip):Void {
		newItem._y = _totalHeight;
		
		_totalHeight += newItem._height + _verticalPadding;
		_internalHeight = _totalHeight;
	}
	
	public function fold():Void {
		_folded = true;
		
		if (smoothedAnimations) TweenLite.to(_itemsContainer, 0.2, { _alpha:0, _y: -10, onComplete:Relegate.create(this, _toggleItemsVisibility, false) } );
		else _toggleItemsVisibility(false);
		
		if (HEADER_FOLDING_INDICATOR_NAME != "") {
			if (smoothedAnimations) TweenLite.to(_header[HEADER_FOLDING_INDICATOR_NAME], 0.2, { _rotation:180 } );
			else _header[HEADER_FOLDING_INDICATOR_NAME]._rotation = 180;
		}
		
		_totalHeight = _header._height;
		
		dispatchEvent(new StatusEvent(StatusEvent.CHANGE));
	}
	
	private function _toggleItemsVisibility(visibility:Boolean):Void {
		_itemsContainer._visible = visibility;
	}
	
	
	public function unfold():Void {
		_folded = false;
		
		if (smoothedAnimations) {
			_toggleItemsVisibility(true);
			TweenLite.to(_itemsContainer, 0.2, { _alpha:100, _y:0 } );
		} else _toggleItemsVisibility(true);
		
		if (HEADER_FOLDING_INDICATOR_NAME != "") {
			if (smoothedAnimations) TweenLite.to(_header[HEADER_FOLDING_INDICATOR_NAME], 0.2, { _rotation:0 } );
			else _header[HEADER_FOLDING_INDICATOR_NAME]._rotation = 0;
		}
		
		_totalHeight = _internalHeight;
		
		dispatchEvent(new StatusEvent(StatusEvent.CHANGE));
	}
	
	public function destroy():Void {
		_header.removeMovieClip();
		
		for (var i:Number = 0; i < _numItems; i++) {
			_items[i].removeMovieClip();
		}
		_items = [];
		
		_content.removeMovieClip();
	}
	
	public function setHeaderContent(labelName:String, text:String):Void {
		_header[labelName].text = text;
	}
	
	public function removeItem(itemToRemove:Number):CategorizedListItemRenderer {
		var removedItem:CategorizedListItemRenderer;
		for (var i:Number = 0; i < _numItems; i++) {
			if (_items[i].id == itemToRemove) {
				removedItem = _items[i];
				_numItems--;
				_items.splice(i, 1);
				break;
			}
		}
		
		return removedItem;
	}
	
	public function updateItemsPlacement():Void {
		_totalHeight = _header._height + _afterHeaderPadding;
		
		var i:Number, item:MovieClip;
		if (smoothedAnimations) {
			for (i = 0; i < _numItems; i++) {
				item = _items[i];
				TweenLite.to(item, 0.1, { _y:_totalHeight } );
				
				_totalHeight += item._height + _verticalPadding;
			}
		} else {
			for (i = 0; i < _numItems; i++) {
				item = _items[i];
				item._y = _totalHeight;
				
				_totalHeight += item._height + _verticalPadding;
			}
		}
		
		_internalHeight = _totalHeight;
	}
	
	public function setWidth(newWidth:Number):Void {
		if (smoothedAnimations) {
			TweenLite.to(_header[BG_NAME], 0.1, { _width: newWidth } );
			TweenLite.to(_header[HEADER_FOLDING_INDICATOR_NAME], 0.1, { _x: newWidth - FOLDING_INDICATOR_RIGHT_OFFSET } );
		} else {
			_header[BG_NAME]._width = newWidth;
			_header[HEADER_FOLDING_INDICATOR_NAME]._x = newWidth - FOLDING_INDICATOR_RIGHT_OFFSET;
		}
		var total:Number = _items.length;
		for (var i:Number = 0; i < total; i++) {
			_items[i]._width = newWidth;
		}
	}
	
	public function get content():MovieClip { return _content; }
	public function get totalHeight():Number { return _totalHeight; }
	public function get id():Number { return _id; }
	public function get folded():Boolean { return _folded; }
	public function get itemsContainer():MovieClip { return _itemsContainer; }
	public function get headerContainer():MovieClip { return _headerContainer; }
	public function get header():MovieClip { return _header; }
	public function get items():Array/*MovieClip*/ { return _items; }
	public function get numItems():Number { return _numItems; }
	
}