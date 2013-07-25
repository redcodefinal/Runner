package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ian Rash
	 */
	public class Bomb extends FlxSprite
	{
		public const BOMBEXPLOSIONDISTANCE:int = 50;
		
		public function Bomb(X:int, Y:int, XVelocity:int, YVelocity:int)
		{
			super(X, Y);
			velocity.x = XVelocity;
			velocity.y = YVelocity;
			
			acceleration.y = 100;
			
			makeGraphic(5, 5, 0xffff2202);
			
			trace("New bomb made");
		}
		
		public function collided():void
		{
			velocity.x = 0;
			velocity.y = 0;
			acceleration.y = 0;
			acceleration.x = 0;
			
			trace("Bomb collided");
		}
		
		override public function update():void 
		{
			super.update();
			
			if (isTouching(ANY))
			{
				collided();
			}
		}
		
		override public function kill():void 
		{
			super.kill();
			trace("Bomb detonated");
		}
	}

}