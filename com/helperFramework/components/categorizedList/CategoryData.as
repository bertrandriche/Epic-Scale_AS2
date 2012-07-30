/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.categorizedList.CategoryData {
	
	private var _id:String;
	private var _items:Array;
	private var _numItems:Number;
	private var _label:String;
	
	public function CategoryData(categoryID:String, categoryLabel:String) {
		_id = categoryID;
		_label = categoryLabel;
		
		_items = [];
		_numItems = 0;
	}
	
	public function addItem(item:Object):Void {
		_items[_numItems] = item;
		_numItems++;
	}
	
	
	
	public function toString():String {
		return "Category " + _id + " with " + _numItems + " items";
	}
	
	public function removeItem(itemToRemove:Number):Void {
		for (var i:Number = 0; i < _numItems; i++) {
			if (_items[i].id == itemToRemove) {
				_items.splice(i, 1);
				_numItems--;
				break;
			}
		}
	}
	
	public function get items():Array { return _items; }
	public function get numItems():Number { return _numItems; }
	public function get label():String { return _label; }
	public function get id():String { return _id; }
	
}