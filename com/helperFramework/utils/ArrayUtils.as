/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.utils.ArrayUtils {
	
	public static function version():String {
		return "V2";
	}
	
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
	
}