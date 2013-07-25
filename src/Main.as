package 
{
	
	import org.flixel.FlxGame;
	
	[SWF(width="500",height="500",backgroundColor="0x000000")]
	[Frame(factoryClass="Preloader")]
	
	/**
	 * ...
	 * @author Ian Rash
	 */
	public class Main extends FlxGame 
	{

		public function Main():void 
		{
			super(250, 250, MenuState, 2, 60, 60);
		}
	}

}