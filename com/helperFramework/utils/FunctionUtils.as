/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.utils.FunctionUtils {
	
	/**
	 * Calls a function after a specified amount of time.
	 * @param	delay					Number		> the delay in milliseconds (1000 = 1 sec)
	 * @param	func					Function	> the Delegate / Relegate reference to the desired function
	 */
	public static function delayedCall(delay:Number, func:Function):Void {
		var interID:Number = setInterval(_onComplete, delay);
		
		function _onComplete():Void {
			clearInterval(interID);
			func();
		}
	}
	
}