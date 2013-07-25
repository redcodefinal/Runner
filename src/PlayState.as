package  
{
	import adobe.utils.CustomActions;
	import org.flixel.*;
	/**
	 * ...
	 * @author Ian Rash
	 */
	public class PlayState extends FlxState
	{
		private var _player:Player;
		private var _spawner:BuildingSpawner;
		
		override public function create():void 
		{
			FlxG.bgColor = 0xff444444;
		    add(new FlxText(10, -120, 100, "YOU DID IT!"));
		
			_player = new Player(50, 100);
			add(_player);
			add(_player.Bombs);
			
			_spawner = new BuildingSpawner(_player);
			_spawner.beginSpawning();
			add(_spawner);
			
			FlxG.mouse.reset();

			super.create();
		}
		
		override public function update():void 
		{
			super.update();
			
			FlxG.collide(_player, _spawner);
			FlxG.collide(_player.Bombs, _spawner);
			//Check if the player fell
			if (_player.y > _spawner.LastBuilding.y + _spawner.LastBuilding.height)
				_player.kill();
			
			if (!_player.alive)
				GameOver();
			
			//Debug testing
			if (FlxG.keys.ENTER)
			{
				for (var i:int = 0; i < this.length; i++)
				{
					this.members[i]
				}
				this.clear();
				FlxG.resetGame();
			}
		}	
		
		public function GameOver():void
		{
			add(new FlxText(100, 100, 300, "YOU LOSE"));
		}
	}

}