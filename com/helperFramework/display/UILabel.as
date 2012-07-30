/**
 * Wrapper for a simple Textfield. Used to simplify Textfield manipulation in AS2.
 * @author bertrandr@funcom.com
 */
class com.helperFramework.display.UILabel {
	
	private var _content:MovieClip;
	private var _textField:TextField;
	private var _format:TextFormat;
	
	/**
	 * Creates a new Label component. Must be initialized by passing a library MovieClip containing a textfield instance named "textField". The Label component is a simple single-line textfield that can be freely customized. Don't forget to call the updateFormat() function each time a change is made on any of the text visual properties (size, color, font, format...).
	 * @param	content
	 */
	public function UILabel(content:MovieClip) {
		_content = content;
		_textField = TextField(_content.textField);
		
		_format = new TextFormat();
		
		_textField.autoSize = true;
	}
	
	public function set text(value:String):Void { 
		_content.textField.text = value; 
	}
	
	public function updateFormat():Void {
		_textField.setNewTextFormat(_format);
	}
	
	public function set format(value:TextFormat):Void { _format = value; }
	public function set size(newSize:Number):Void { _format.size = newSize; }
	public function set color(newColor:Number):Void { _format.color = newColor; }
	public function set font(newFont:String):Void { _format.font = newFont; }
	
	
	public function get _width():Number { return _content._width; }
	public function set _width(value:Number):Void { _content._width = value; }
	
	public function get _height():Number { return _content._height; }
	public function set _height(value:Number):Void { _content._height = value; }
	
	public function get _x():Number { return _content._x; }
	public function set _x(value:Number):Void { _content._x = value; }
	
	public function get _y():Number { return _content._y; }
	public function set _y(value:Number):Void { _content._y = value; }
	
	public function get text():String { return _textField.text; }
	public function get content():MovieClip { return _content; }
	public function get textField():TextField { return _textField; }
	public function get format():TextFormat { return _format; }
	public function get size():Number { return _format.size; }
	public function get color():Number { return _format.color; }
	public function get font():String { return _format.font; }
	
}