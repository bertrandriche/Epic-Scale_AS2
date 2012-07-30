/**
 * Utility class that holds various methods used with Arrays.
 * @author bertrandr@funcom.com
 */
class com.helperFramework.utils.ArrayUtils {
	
	/**
	 * Defines if an element can be found in the supplied Array.
	 * @param	value			The element to search
	 * @param	collection		The Array to search the element in
	 * @param	recursive		Boolean defining if the search must be recursive or not (if the function must search in any Array found inside the mother supplied Array).
	 * @return				If the item has been found or not
	 */
	public static function isInArray(value:Object, collection:Array, recursive:Boolean):Boolean {
		if (recursive == undefined || recursive == null) recursive = false;
		
		var tempResult:Boolean = false;
		
		var total:Number = collection.length;
		for (var i:Number = 0; i < total; i++) {
			if (recursive && collection[i] instanceof Array) {
				tempResult = isInArray(value, collection[i], true);
				if (tempResult) return true;
			} else {
				if (collection[i] == value) {
					return true;
				}
			}
		}
		return false;
	}
	
	/**
	 * Returns the index of the searched element in the provided Array. Can search for sub-items if an elements of the provided Array is also an Array.
	 * @param	value				The value to search
	 * @param	collection			The Array to search in
	 * @param	referenceIndex		A Number defining wich element must be s searched in if the items of the mother provided Array are also Arrays. Default : 0 (first element).
	 * @return				The index of the element if found. -1 if not.
	 */
	public static function indexOf(value:Object, collection:Array, referenceIndex:Number):Number {
		if (referenceIndex == null || referenceIndex == undefined) referenceIndex = 0;
		
		var total:Number = collection.length;
		for (var i:Number = 0; i < total; i++) {
			if (collection[i] instanceof Array) {
				if (collection[i][referenceIndex] == value) return i;
			} else {
				if (collection[i] == value) return i;
			}
		}
		return -1;
	}
	
	/**
	 * Returns the last index of the searched element in the provided Array. Can search for sub-items if an elements of the provided Array is also an Array.
	 * @param	value				The value to search
	 * @param	collection			The Array to search in
	 * @param	referenceIndex		A Number defining wich element must be s searched in if the items of the mother provided Array are also Arrays. Default : 0 (first element).
	 * @return				The index of the element if found. -1 if not.
	 */
	public static function lastIndexOf(value:Object, collection:Array, referenceIndex:Number):Number {
		if (referenceIndex == null || referenceIndex == undefined) referenceIndex = 0;
		
		var total:Number = collection.length;
		for (var i:Number = total - 1; i >= 0; i--) {
			if (collection[i] instanceof Array) {
				if (collection[i][referenceIndex] == value) return i;
			} else {
				if (collection[i] == value) return i;
			}
		}
		return -1;
	}
	
	public static function version():String { return "V2"; }
	
}