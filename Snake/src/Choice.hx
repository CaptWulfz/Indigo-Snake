package;

import openfl.text.TextField;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Jesin Jarod Martinez
 */
class Choice extends TextField
{
	private var hoverOverColor = 0xFFFF0000;
	private var hoverOutColor = 0x32CD32;

	public function new() 
	{
		super();
		this.background = true;
		this.border = true;
		this.backgroundColor = hoverOutColor;
		this.width = 300;
		this.height = 60;
		this.text = text;
		this.sharpness = 400;
		this.addEventListener(MouseEvent.ROLL_OVER, hoveredOver);
		this.addEventListener(MouseEvent.ROLL_OUT, hoveredOut);
	}
	
	private function hoveredOver(event:MouseEvent):Void{
		this.backgroundColor = hoverOverColor;
	}
	
	private function hoveredOut(event:MouseEvent):Void{
		this.backgroundColor = hoverOutColor;
		
	}
}