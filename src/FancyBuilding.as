package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Ian Rash
	 */
	public class FancyBuilding extends FlxObject
	{
		public var Group:FlxGroup;
		private var _rightside:FlxSprite;
		private var _leftside:FlxSprite;
		private var _insides:FlxGroup;
		private var _player:Player;
		
		public function FancyBuilding(X:int, Y:int, NumberOfInnerPanels:int, player:Player)
		{
			super(X, Y);
			Group = new FlxGroup();
			
			_leftside = new FlxSprite(X, Y-5, Reg.BuildingLeftSide);
			_leftside.immovable = true;
			Group.add(_leftside);
			
			_insides = new FlxGroup(NumberOfInnerPanels);
			var offset:int = _leftside.width;
			for (var i:int = 0; i < NumberOfInnerPanels; i++)
			{
				var inside:FlxSprite = new FlxSprite(X + offset, Y, Reg.BuildingInside);
				inside.immovable = true;
				_insides.add(inside);
				offset += inside.width
			}
			Group.add(_insides);
			
			_rightside = new FlxSprite(X + offset, Y, Reg.BuildingRightSide);
			_rightside.immovable = true;
			Group.add(_rightside);
			
			//Move the bounds down to prevent collision with the top ladder part.
			x -= 5;
			width = offset;
			height = _leftside.height;
			
			_player = player;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (x + width > _player.x - 200)
			{
				destroy();
			}
		}
		
		
		override public function destroy():void 
		{
			super.destroy();
			
			_insides.destroy();
			
			_leftside.destroy();
			_rightside.destroy();
			Group.destroy();
		}		
	}

}