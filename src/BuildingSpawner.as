package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ian Rash
	 */
	public class BuildingSpawner extends FlxGroup
	{
		public var LastBuilding:Building;
		public var IsSpawning:Boolean;
		
		private var _player:Player;
		
		private const MINBUILDINGWIDTH:int = 100;
		private const MAXBUILDINGWIDTH:int = 400;
		
		private const MAXBUILDINGGAPX:int = 200;
		private const MINBUILDINGGAPX:int = 50;
		
		private const MAXBUILDINGGAPY:int = 10;
		private const MINBUILDINGGAPY:int = -10;
		
		public function BuildingSpawner(player:Player) 
		{
			super();
			
			_player = player;
		}
		
		public function addBuilding(X:int, Y:int, Width:int, Height:int)
		{
			var b:Building = new Building(X, Y, Width, Height, _player);
			LastBuilding = b;
			this.add(b);
		}
		
		override public function update():void 
		{
			super.update();
			
			spawnWork();
		}
		
		public function spawnWork()
		{
			if (IsSpawning)
			{
				if (LastBuilding.x + LastBuilding.width + MINBUILDINGGAPX > FlxG.width + 200)
				{
					spawnBuilding();
				}
			}
		}
		
		public function spawnBuilding()
		{
			//Create a new building based off the values of the old one.
			var gapx:int = getRandomBuildingGapX();
			var gapy:int = getRandomBuildingGapY();
			var width:int = getRandomBuildingWidth();
			
			addBuilding(LastBuilding.x + LastBuilding.width + gapx, LastBuilding.y + gapy, width, 400);
		}
		
		public function beginSpawning()
		{
			IsSpawning = true;
			
			//if there are no members create a platform under the player and plats for the player to jump to.
			if (this.members.length == 0)
			{
				addBuilding(_player.x - 50, _player.y + 20, getRandomBuildingWidth(), 400);
				spawnBuilding();
				spawnBuilding();
			}
		}
		
		public function stopSpawning()
		{
			IsSpawning = false;
		}
		
		public function getRandomBuildingWidth():int
		{
			return Math.random() * MAXBUILDINGWIDTH + MINBUILDINGWIDTH;
		}
		
		public function getRandomBuildingGapX():int
		{
			return Math.random() * MAXBUILDINGGAPX + MINBUILDINGGAPX;
		}
		
		public function getRandomBuildingGapY():int
		{
			return Math.random() * (MAXBUILDINGGAPY - MINBUILDINGGAPY) + MINBUILDINGGAPY;
		}
		
	}

}