package;

/**
 * ...
 * @author Jesin Jarod Martinez
 */
class MoveState 
{
	public var pendingX:Float;
	public var pendingY:Float;
	public var pendingDir:Direction;

	public function new(x:Float, y:Float, dir:Direction) 
	{
		this.pendingX = x;
		this.pendingY = y;
		this.pendingDir = dir;
	}
	
}