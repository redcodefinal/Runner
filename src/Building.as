package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ian Rash
	 */
	public class Building extends FlxSprite
	{
	    private var _player:Player;
		
		public function Building(X:int, Y:int, Width:int, Height:int, player:Player)
		{
			super(X, Y);
			
			solid = true;
			this.immovable = true;
			width = Width;
			height = Height;
			_player = player;
			
			makeGraphic(Width, Height, 0xff0033ff);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
	}

}