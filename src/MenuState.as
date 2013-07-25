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
			
			var text:FlxText = new FlxText(FlxG.width / 2 - 200, 400, 1000, "X = Jump, C = Brake, Space = Throw/Denotnate Bomb, Enter = Restart, Press X");
			text.color = 0xffffffff;
			text.visible = true;
			add(text);
			
			var othertext = new FlxText(FlxG.width / 2 - 200, 300, 1000, "welcome to C4IA! (C-Phoria)");
			text.color = 0xffffffff;
			text.visible = true;
			add(othertext);
			
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