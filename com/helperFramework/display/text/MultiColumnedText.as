import com.helperFramework.display.UILabel;
/**
 * ...
 * @author bertrandr@funcom.com
 */
class com.helperFramework.display.text.MultiColumnedText {
	
	private var _container:MovieClip;
	
	private var _columns:Number = 1;
	private var _maxWidth:Number = 1;
	private var _columnsWidth:Number = 0;
	public var columnsSpacing:Number = 10;
	
	public static var delimiter:String = "\n\r";
	
	public function MultiColumnedText(container:MovieClip) {
		_container = container;
	}
	
	public function set text(text:String):Void {
		if (_columns < 2) {
			_createNewContent(text);
		} else {
			_createColumns(text, _columns, 0);
		}
	}
	public function set columns(value:Number):Void { 
		_columns = value;
		_columnsWidth = Math.floor(_maxWidth / _columns);
	}
	public function set maxWidth(value:Number):Void { 
		_maxWidth = value;
		_columnsWidth = Math.floor(_maxWidth / _columns);
	}
	public function get columns():Number { return _columns; }
	public function get maxWidth():Number { return _maxWidth; }
	public function get text():String { return ""; }
	
	
	private function _createColumns(text:String, columnsNum:Number, startingY:Number):Void {
		var xOffset:Number = Math.floor((_maxWidth - (columnsNum * _columnsWidth)) * 0.5);
		var yOffset:Number = startingY;
		
		var newContent:UILabel;
		var lines:Array = text.split(delimiter);
		
		var total:Number = lines.length;
		for (var k:Number = 0; k < total; k++) {
			if (lines[k] == "") {
				lines.splice(k, 1);
				k--;
				total --;
			}
		}
		
		var spareLines:Number = lines.length % columnsNum;
		var lineOffset:Number = spareLines > 0 ? 0 : 0;
		var linesPerColumn:Number = (lines.length) / columnsNum;
		var tempText:String;
		for (var i:Number = 0; i < columnsNum; i++) {
			tempText = "";
			for (var j:Number = 0; j < linesPerColumn - lineOffset; j++) {
				if (lines.length > 0) tempText += lines.shift() + "<br/>";
				else tempText += "<br/>";
			}
			lineOffset = 0;
			newContent = _createNewContent(tempText, i, columnsNum);
			newContent._x = i * _columnsWidth + xOffset;
			if (i % 2 == 0) newContent._x -= columnsSpacing;
			else if (i % 2 == 1) newContent._x += columnsSpacing;
			newContent._y = yOffset;
			if (newContent._y + newContent._height > startingY) startingY = newContent._y + newContent._height;
		}
	}
	
	
	private function _createNewContent(newText:String, currentColumn:Number, totalColumns:Number):UILabel {
		var newLabel:UILabel = new UILabel(_container.attachMovie("AocLabel", "text" + _container.getNextHighestDepth(), _container.getNextHighestDepth()));
		
		newLabel.textField._width = _columnsWidth;
		
		if (ParserHelper.DEBUG_MODE) {
			newLabel.textField.border = true;
			newLabel.textField.borderColor = 0xFF0000;
		}
		
		newLabel.textField.multiline = true;
		newLabel.textField.wordWrap = true;
		newLabel.textField.html = true;
		newLabel.textField.htmlText = newText;
		newLabel.textField.mouseWheelEnabled = false;
		newLabel.textField.tabEnabled = false;
		
		if (totalColumns == 2) {
			if (currentColumn == 0) {
				newLabel.format.align = "right";
			} else if (currentColumn == 1) {
				newLabel.format.align = "left";
			}
			newLabel.textField.setTextFormat(newLabel.format);
		}
		
		return newLabel;
	}
	
	public function get height():Number {
		return _container._height;
	}
	public function set y(value:Number):Void {
		_container._y = value;
	}
	
}