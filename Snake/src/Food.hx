package;

import openfl.display.Sprite;

/**
 * ...
 * @author Jesin Jarod Martinez
 */
class Food extends Sprite
{

	public function new() 
	{
		super();
		this.graphics.beginFill(0xFFFFFFFF);
		this.graphics.drawRect(0, 0, 10, 10);
		this.graphics.endFill();
	}
	
}