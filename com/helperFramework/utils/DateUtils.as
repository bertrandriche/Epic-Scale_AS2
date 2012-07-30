/**
 * Utility class to convert seconds to other usable formats.
 * @author bertrandr@funcom.com
 */
class com.helperFramework.utils.DateUtils{
	
	static public function formatSecondsToMinutes(seconds:Number):String {
		var duration:String = "";
		
		var m:Number = Math.floor((seconds / 60) % 60);
		var s:Number = seconds % 60;
		
		duration += (m > 9 ? m : "0" + m) + ":" + (s > 9 ? s : "0" + s);
		
		return duration;
	}
	
	/**
	 * Converts a number of seconds into an Array or Numbers from seconds to weeks. Seconds will always be the last value in the Array.
	 * @param	seconds
	 * @return			An Array able to contain from weeks to seconds. Empty values will not be returned (ex : if weeks = 0 and days = 0, the Array will contain only hours, minutes & seconds).
	 */
	static public function formatTime(seconds:Number):Array {
		var times:Array = new Array(5);
		times[0] = Math.floor(seconds / 86400 / 7); // weeks
		times[1] = Math.floor(seconds / 86400 % 7); // days
		times[2] = Math.floor(seconds / 3600 % 24); // hours
		times[3] = Math.floor(seconds / 60 % 60); // mins
		times[4] = Math.floor(seconds % 60); // secs
		
		var stopage:Boolean = false;
		var cutIndex:Number = -1;
		
		for (var i:Number = 0; i < times.length; i++) {
			if (times[i] < 10) {
				times[i] = "0" + times[i];
			}
			if (times[i] == "00" && i < (times.length - 2) && !stopage) {
				cutIndex = i;
			} else {
				stopage = true;
			}
		}
		times.splice(0, cutIndex + 1);
		
		return times;
	}
	
}