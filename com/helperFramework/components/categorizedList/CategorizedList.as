import com.helperFramework.components.categorizedList.CategorizedListEvent;
import com.helperFramework.components.categorizedList.CategorizedListItemRenderer;
import com.helperFramework.components.categorizedList.CategoryData;
import com.helperFramework.components.categorizedList.CategoryView;
import com.greensock.TweenLite;
import com.helperFramework.events.MouseEvent;
import com.helperFramework.events.StatusEvent;
import com.helperFramework.utils.ArrayUtils;
import com.helperFramework.utils.Relegate;
import gfx.controls.ScrollBar;
import gfx.events.EventDispatcher;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.categorizedList.CategorizedList extends EventDispatcher {
	
	public var itemsTypesPadding:Number = 5;
	private var _smoothedAnimations:Boolean = true;
	
	public var verticalSpacingBeforeHeader:Number = 10;
	public var verticalSpacingAfterHeader:Number = 3;
	public var itemsVerticalSpacing:Number = 0;
	public var autoScrollDistance:Boolean = true;
	public var scrollDistance:Number = 5;
	
	private var _itemsRenderersName:String;
	private var _categoriesRenderersName:String;
	private var _itemsCategoryProperty:String = "category";
	private var _itemsCategoryLabelProperty:String = "categoryLabel";
	private var _categoriesLabelName:String = "label";
	
	private var _content:MovieClip;
	private var _totalWidth:Number;
	private var _totalHeight:Number;
	private var _scrollBarOn:Boolean;
	
	private var _populated:Boolean = false;
	private var _categories:Array/*CategoryData*/;
	private var _numCategories:Number;
	private var _singleElementHeight:Number = -1;
	
	private var _contentContainer:MovieClip;
	private var _contentMask:MovieClip;
	private var _categoriesViews:Array/*CategoryView*/;
	private var _scrollBar:ScrollBar;
	private var _scrollPosition:Number = 0;
	private var _scrollableDistance:Number;
	
	private var _selectedElement:CategorizedListItemRenderer;
	
	public function CategorizedList(container:MovieClip, itemsRenderersName:String, categoriesRenderersName:String, totalWidth:Number, totalHeight:Number, scrollBarOn:Boolean) {
		_content = container;
		_categoriesRenderersName = categoriesRenderersName;
		_itemsRenderersName = itemsRenderersName;
		_totalWidth = totalWidth;
		_totalHeight = totalHeight;
		_scrollBarOn = scrollBarOn;
		
		_createScrollBar();
		
		_contentContainer = _content.createEmptyMovieClip("contentContainer", _content.getNextHighestDepth());
		_content._alpha = 0;
		
		_contentMask = _createContentMask();
		_contentContainer.setMask(_contentMask);
	}
	
	
	public function focusOn(catID:Number):Void {
		for (var i:Number = 0; i < _numCategories; i++) {
			if (i != catID) _categoriesViews[i].fold();
			else _categoriesViews[i].unfold();
		}
		
		_updateLayout(true);
	}
	
	/*************************************************************************
	******************************* SHOW / HIDE ******************************
	**************************************************************************/
	
	public function show(animated:Boolean, endCallBack:Function):Void {
		if (animated == null || animated == undefined) animated = false;
		if (animated) {
			if (endCallBack != null) TweenLite.to(_content, 0.1, { _alpha:100, onComplete:endCallBack } );
			else TweenLite.to(_content, 0.1, { _alpha:100 } );
		} else {
			_content._alpha = 100;
			if (endCallBack != null) endCallBack();
		}
		
	}
	
	public function hide(animated:Boolean, endCallBack:Function):Void {
		if (animated == null || animated == undefined) animated = false;
		if (animated) {
			if (endCallBack != null) TweenLite.to(_content, 0.1, { _alpha:0, onComplete:endCallBack } );
			else TweenLite.to(_content, 0.1, { _alpha:0 } );
		} else {
			_content._alpha = 0;
			if (endCallBack != null) endCallBack();
		}
		
	}
	
	
	/*************************************************************************
	************************ POPULATION & UNPOPULATION ***********************
	**************************************************************************/
	
	public function populate(data:Array):Void {
		
		_content._alpha = 0;
		
		if (_populated) unpopulate();
		_populated = true;
		
		_categories = [];
		_numCategories = 0;
		
		var existingCategories:Array = [];
		
		var catName:String;
		var total:Number = data.length;
		for (var i:Number = 0; i < total; i++) {
			catName = data[i][_itemsCategoryProperty];
			if (!ArrayUtils.isInArray(catName, existingCategories)) {
				_addCategory(catName, data[i][_itemsCategoryLabelProperty]);
				existingCategories.push(catName);
			}
			_addItemUnder(catName, data[i]);
		}
		
		_categories.sortOn("name");
		
		_populateVisuals();
	}
	
	private function _addItemUnder(categoryID:String, data:Object):Void {
		var catIndex:Number;
		for (var i:Number = 0; i < _numCategories; i++) {
			if (_categories[i].id == categoryID) {
				catIndex = i;
				break;
			}
		}
		
		_categories[catIndex].addItem(data);
	}
	
	private function _addCategory(categoryID:String, categoryNameLabel:String):Void {
		_categories[_numCategories] = new CategoryData(categoryID, categoryNameLabel);
		_numCategories++;
	}
	
	
	
	public function removeElement(itemToRemove:Number, targetCategory:String):Void {
		var categoryData:CategoryData;
		if (targetCategory == null || targetCategory == undefined || targetCategory == "") {
			categoryData = _retrieveCategoryForItem(itemToRemove);
		} else {
			categoryData = _getCategory(targetCategory);
		}
		
		categoryData.removeItem(itemToRemove);
		
		var subTotal:Number;
		var removedItem:CategorizedListItemRenderer;
		for (var i:Number = 0; i < _numCategories; i++) {
			if (_categoriesViews[i].id == categoryData.id) {
				removedItem = _categoriesViews[i].removeItem(itemToRemove);
				
				if (removedItem == _selectedElement) _unselectCurrentElement();
				removedItem.removeAllEventListeners();
				TweenLite.to(removedItem, 0.1, { _alpha:0, onComplete:Relegate.create(this, _deleteElement, i, removedItem) } );
				
				if (_categoriesViews[i].numItems < 1) {
					TweenLite.to(_categoriesViews[i].content, 0.1, { _alpha:0, onComplete:Relegate.create(this, _deleteCategory, i) } );
				}
				break;
			}
		}
	}
	
	private function _deleteCategory(categoryIndex:Number):Void {
		_categoriesViews[categoryIndex].destroy();
		_categoriesViews.splice(categoryIndex, 1);
	}
	
	private function _deleteElement(categoryIndex:Number, removedItem:CategorizedListItemRenderer):Void {
		removedItem.removeMovieClip();
		
		_categoriesViews[categoryIndex].updateItemsPlacement();
		
		_updateLayout(true);
	}
	
	
	
	
	public function unpopulate():Void {
		
		for (var i:Number = 0; i < _numCategories; i++) {
			_categoriesViews[i].removeAllEventListeners();
			_categoriesViews[i].destroy();
		}
		
		_categoriesViews = [];
		_categories = [];
		_numCategories = 0;
		_singleElementHeight = -1;
		
		_toggleScrollBar(false);
	}
	
	/*************************************************************************
	*************************** ELEMENTS SELECTION ***************************
	**************************************************************************/
	
	private function _onItemClick(evt:Object):Void {
		var target:CategorizedListItemRenderer = CategorizedListItemRenderer(evt.target);
		
		if (target == _selectedElement) {
			_unselectCurrentElement();
		} else {
			_unselectCurrentElement();
			
			_selectedElement = CategorizedListItemRenderer(target);
			
			_selectedElement.selected = true;
			_selectedElement.focused = 1;
			
		}
		
		dispatchEvent(new CategorizedListEvent(CategorizedListEvent.SELECTION_CHANGE, _selectedElement));
		
		Selection.setFocus(null);
	}
	
	private function _unselectCurrentElement():Void {
		if (_selectedElement == null) return;
		
		_selectedElement.selected = false;
		_selectedElement.focused = 0;
		
		_selectedElement = null;
	}
	
	public function unselect():Void {
		_unselectCurrentElement();
	}
	
	/*************************************************************************
	************************ LAYOUT CREATION & UPDATE ************************
	**************************************************************************/
	
	private function _populateVisuals():Void {
		
		var itemsInCat:Array;
		var newItem:MovieClip;
		
		var categoryView:CategoryView;
		_categoriesViews = [];
		
		for (var i:Number = 0; i < _numCategories; i++) {
			
			categoryView = new CategoryView(_categories[i].id, _contentContainer.createEmptyMovieClip("category_" + _categories[i].id, _contentContainer.getNextHighestDepth()), verticalSpacingAfterHeader, itemsVerticalSpacing, _smoothedAnimations);
			categoryView.setHeader(categoryView.headerContainer.attachMovie(_categoriesRenderersName, "header", categoryView.headerContainer.getNextHighestDepth()));
			categoryView.setHeaderContent(_categoriesLabelName, _categories[i].label);
			categoryView.addEventListener(StatusEvent.CHANGE, Relegate.create(this, _onCategoryChange));
			//categoryView.header._width = _totalWidth - itemsTypesPadding;
			categoryView.setWidth(_totalWidth - itemsTypesPadding);
			
			_categoriesViews[i] = categoryView;
			
			itemsInCat = _categories[i].items;
			for (var j:Number = 0; j < _categories[i].numItems; j++) {
				newItem = categoryView.itemsContainer.attachMovie(_itemsRenderersName, "item" + j, categoryView.itemsContainer.getNextHighestDepth());
				newItem.setData(itemsInCat[j]);
				newItem._width = _totalWidth - itemsTypesPadding;
				newItem.doubleClickEnabled = true;
				newItem.addEventListener(MouseEvent.CLICK, Relegate.create(this, _onItemClick));
				
				if (_singleElementHeight == -1) {
					_singleElementHeight = newItem._height;
					if (autoScrollDistance) scrollDistance = _singleElementHeight + itemsVerticalSpacing;
				}
				
				_categoriesViews[i].addItem(newItem);
			}
		}
		
		_updateElementsWidth(_scrollBar._visible);
		
		_updateLayout(false);
		
	}
	
	
	private function _onCategoryChange(evt:Object):Void {
		if (ArrayUtils.isInArray(_selectedElement, CategoryView(evt.target).items, false)) {
			_unselectCurrentElement();
			dispatchEvent(new CategorizedListEvent(CategorizedListEvent.SELECTION_CHANGE, null));
		}
		
		_updateLayout(true);
		
		Selection.setFocus(null);
	}
	
	
	private function _updateLayout(animated:Boolean):Void {
		if (animated == null || animated == undefined) animated = true;
		
		var yOffest:Number = 0;
		
		for (var i:Number = 0; i < _numCategories; i++) {
			if (yOffest!= _categoriesViews[i].content._y) {
				if (animated && smoothedAnimations) TweenLite.to(_categoriesViews[i].content, 0.2, { _y:yOffest } );
				else _categoriesViews[i].content._y = yOffest;
			}
			yOffest += _categoriesViews[i].totalHeight + verticalSpacingBeforeHeader;
		}
		
		_scrollableDistance = yOffest;
		
		if (_scrollBarOn) {
			_toggleScrollBar(_scrollableDistance > _totalHeight);
			_updateScrollBar();
		}
	}
	
	
	
	private function _createContentMask():MovieClip {
		var mask:MovieClip = _content.createEmptyMovieClip("contentMask", _content.getNextHighestDepth());
		mask.beginFill(0xFF0000);
		mask.lineTo(_totalWidth, 0);
		mask.lineTo(_totalWidth, _totalHeight);
		mask.lineTo(0, _totalHeight);
		mask.lineTo(0, 0);
		mask.endFill();
		
		return mask;
	}
	
	
	/*************************************************************************
	******************************** SCROLLBAR *******************************
	**************************************************************************/
	
	private function _createScrollBar():Void {
		_scrollBar = ScrollBar(_content.attachMovie("ScrollBar", "scrollbar", _content.getNextHighestDepth()));
		_scrollBar._visible = false;
		_scrollBar._x = _totalWidth - _scrollBar._width - itemsTypesPadding;
		_scrollBar._y = itemsTypesPadding;
		_scrollBar.height = _totalHeight - itemsTypesPadding * 2;
		_scrollBar.trackScrollPageSize = _singleElementHeight;
		
		if (_scrollBar.setScrollProperties != null) {
			_scrollBar.addEventListener("scroll", Relegate.create(this, _onListScroll));
		} else {
			_scrollBar.addEventListener("change", Relegate.create(this, _onListScroll));
		}
		_scrollBar.focusTarget = this;
		_scrollBar.tabEnabled = false;
	}
	
	private function _updateScrollBar():Void {
		_scrollBar.setScrollProperties(_totalHeight, 0, _scrollableDistance - _totalHeight, _singleElementHeight);
		_scrollBar.position = _scrollPosition;
		
		_scrollTo(_scrollPosition);
	}
	
	private function _onListScroll(event:Object):Void {
		if (_scrollableDistance < _totalHeight) return;
		
		var newPosition:Number = event.target.position;
		if (isNaN(newPosition)) return;
		_scrollTo(newPosition);
	}
	
	public function scrollTo(distance:Number):Void {
		if (_scrollableDistance < _totalHeight) return;
		
		var newPosition:Number = _scrollPosition + distance;
		_scrollTo(newPosition);
		
		if (_scrollBarOn && _scrollBar != null) {
			_scrollBar.position = newPosition;
		}
	}
	
	private function _scrollTo(newPosition:Number):Void {
		_scrollPosition = newPosition;
		if (_scrollPosition < 0) _scrollPosition = 0;
		if (_scrollPosition > _scrollableDistance - _totalHeight) _scrollPosition = _scrollableDistance - _totalHeight;
		
		if (smoothedAnimations) {
			if (_contentContainer._y + _scrollableDistance >= _totalHeight) {
					TweenLite.to(_contentContainer, 0.1, { _y: 0 - _scrollPosition } );
			} else {
				if (0 - _scrollableDistance + _totalHeight < 0) TweenLite.to(_contentContainer, 0.1, { _y: 0 - _scrollableDistance + _totalHeight } );
				else TweenLite.to(_contentContainer, 0.1, { _y: 0 } );
			}
		} else {
			if (_contentContainer._y + _scrollableDistance >= _totalHeight) {
				_contentContainer._y = 0 - _scrollPosition;
			} else {
				if (0 - _scrollableDistance + _totalHeight < 0) _contentContainer._y = 0 - _scrollableDistance + _totalHeight;
				else _contentContainer._y = 0;
			}
		}
		
	}
	
	private function _toggleScrollBar(displayed:Boolean):Void {
		if (displayed == _scrollBar._visible) return; 
		_scrollBar._visible = displayed;
		_updateElementsWidth(displayed);
	}
	
	private function _updateElementsWidth(scrollDisplayed:Boolean):Void {
		var availableWidth:Number = scrollDisplayed ? _totalWidth - _scrollBar._width - itemsTypesPadding * 2 :  _totalWidth - itemsTypesPadding;
		
		var itemsInCat:Array/*MovieClip*/;
		var subTotal:Number;
		
		for (var i:Number = 0; i < _numCategories; i++) {
			_categoriesViews[i].setWidth(availableWidth, _smoothedAnimations);
		}
	}
	
	
	
	
	
	
	
	private function _retrieveCategoryForItem(itemToRemove:Number):CategoryData {
		var itemsInCat:Array;
		for (var i:Number = 0; i < _numCategories; i++) {
			for (var j:Number = 0; j < _categories[i].numItems; j++) {
				if (_categories[i].items[j].id == itemToRemove) {
					return _categories[i];
				}
			}
		}
		return null;
	}
	
	private function _getCategory(targetCategory:String):CategoryData {
		for (var i:Number = 0; i < _numCategories; i++) {
			if (_categories[i].id == targetCategory) return _categories[i];
		}
		return null;
	}
	
	
	/*************************************************************************
	****************************** DESTRUCTION *******************************
	**************************************************************************/
	
	public function destroy():Void {
		unpopulate();
	}
	
	public function get itemsCategoryProperty():String { return _itemsCategoryProperty; }
	public function set itemsCategoryProperty(value:String):Void { _itemsCategoryProperty = value; }
	public function get categoriesLabelName():String { return _categoriesLabelName; }
	public function set categoriesLabelName(value:String):Void { _categoriesLabelName = value; }
	public function get content():MovieClip { return _content; }
	public function get selectedElement():CategorizedListItemRenderer { return _selectedElement; }
	public function get smoothedAnimations():Boolean { return _smoothedAnimations; }
	public function set smoothedAnimations(value:Boolean):Void { 
		_smoothedAnimations = value; 
		var total:Number = _categoriesViews.length;
		for (var i:Number = 0; i < total; i++) {
			_categoriesViews[i].smoothedAnimations = _smoothedAnimations;
		}
	}
	public function get populated():Boolean { return _populated; }
	public function get numCategories():Number { return _numCategories; }
	public function get categoriesViews():Array/*CategoryView*/ { return _categoriesViews; }
	
}