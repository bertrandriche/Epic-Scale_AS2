/**
 * Data object for defining the data of a category within a CategorizedList.
 * @author bertrandr@funcom.com
 */
class com.helperFramework.components.categorizedList.CategoryData {
	
	private var _id:String;
	private var _items:Array;
	private var _numItems:Number;
	private var _label:String;
	
	/**
	 * Constructor
	 * @param	categoryID				The ID of the category as a String (forced by the current engine to do that)
	 * @param	categoryLabel			The label of the category to display to the user
	 */
	public function CategoryData(categoryID:String, categoryLabel:String) {
		_id = categoryID;
		_label = categoryLabel;
		
		_items = [];
		_numItems = 0;
	}
	
	/**
	 * Adds an item
	 * @param	item			The item to add to the category. Can be anything, thus the Object format.
	 */
	public function addItem(item:Object):Void {
		_items[_numItems] = item;
		_numItems++;
	}
	
	/**
	 * Removes an item
	 * @param	itemToRemove	The item ID to remove from the category.
	 */
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