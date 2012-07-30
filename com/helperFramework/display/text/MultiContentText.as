import com.helperFramework.display.text.MultiColumnedText;

/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.display.text.MultiContentText extends MovieClip {
	
	public var maxWidth:Number = 1;
	public var animationActive:Boolean = false;
	private var _yOffset:Number;
	
	public function MultiContentText() {
		_yOffset = 0;
	}
	public function addContent(text:String, colsNum:Number):Void {
		var newTextContent:MultiColumnedText = new MultiColumnedText(this.createEmptyMovieClip("text" + this.getNextHighestDepth(), this.getNextHighestDepth()));
		newTextContent.columns = colsNum;
		newTextContent.maxWidth = maxWidth;
		newTextContent.text = text;
		newTextContent.y = _yOffset;
		_yOffset += newTextContent.height;
	}
	
}