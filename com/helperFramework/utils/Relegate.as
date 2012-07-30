/**
 * Relegate for calling Functions in AS2 and solving scope problems.
 * @author bertrandr@funcom.com
 */
class com.helperFramework.utils.Relegate extends Object {
	
	static function create(scope:Object, callback:Function):Function {
		var args:Array = arguments.splice(2);
		return function() {
			return callback.apply (
				scope,
				arguments.concat(args)
			);
		};
	}
}