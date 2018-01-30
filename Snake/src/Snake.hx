package;

import openfl.display.Sprite;

/**
 * ...
 * @author Jesin Jarod Martinez
 */
class Snake extends Sprite
{
	public function new(x:Float, y:Float) 
	{
		super();
		this.graphics.beginFill(0xD3D3D3);
		this.graphics.drawRect(0, 0, 15, 15);
		this.graphics.endFill();
		

		
		this.x = x;
		this.y = y;
	
	}
}