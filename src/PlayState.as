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
		
			_player = new Player(50, 100, this);
			add(_player);
			
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
			FlxG.collide(_player.Explosive, _spawner);
			//Check if the player fell
			if (_player.y > _spawner.LastBuilding.y + _spawner.LastBuilding.height)
				_player.kill();
			
			if (!_player.alive)
				GameOver();
			
			//Debug testing
			if (FlxG.keys.ENTER)
			{
				for each(var o:* in members)
				{
					var object:FlxBasic = o as FlxBasic;
					object.destroy();
				}
				this.clear();
				FlxG.resetGame();
			}
		}	
		
		public function GameOver():void
		{
			var text:FlxText = new FlxText(200, 200, 200, "YOU LOSE!");
			text.scrollFactor = new FlxPoint(0, 0);
			add(text);
		}
	}

}