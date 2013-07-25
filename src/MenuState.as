package  
{
	import org.flixel.FlxState;
	import org.flixel.*;
	/**
	 * ...
	 * @author Ian Rash
	 */
	public class MenuState extends FlxState
	{
		private var startButton:FlxButton;
 
        public function MenuState()
        {

        }
 
        override public function create():void
        {
            FlxG.mouse.show();
		    FlxG.bgColor = 0xffbbbbbb;
			
			var text:FlxText = new FlxText(FlxG.width / 2 - 50, 200, 100, "X = Jump, C = Brake, Press X");
			text.color = 0xffffffff;
			text.visible = true;
			add(text);
			
			super.create();
        }
		
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.X)
			{
				FlxG.switchState(new PlayState);
			}
		}
	}       

}