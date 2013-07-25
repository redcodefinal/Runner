package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Ian Rash
	 */
	class Player extends FlxSprite
	{
		private var _trackingPoint:FlxObject;
		public var Camera:FlxCamera;
		public var Bombs:FlxGroup;
		
		public var IsBraking:Boolean;
		
		public var IsJumping:Boolean;
		public var JumpKeyReleased:Boolean;
		private var _lastJumpTimerProgress:Number;
		
		private var _jumpTimer:FlxTimer;
		
		public const MINBRAKESPEED:int = 20;
		public const MAXJUMPHEIGHT:int = 100;
		public const BOMBTHROWSPEED:int = 20;
		
		public function Player(X:int, Y:int)
		{
			super(X, Y);
			makeGraphic(6, 12, 0xff22cc44);
			
			solid = true;
			maxVelocity.x = 400;
			maxVelocity.y = 1000;
			acceleration.x = 0;
			acceleration.y = 100;
			velocity.x = 0;
			
			_trackingPoint = new FlxObject();
			
		    //Add our camera
			Camera = new FlxCamera(0, 0, FlxG.width*2, FlxG.height*2, 1);
			Camera.follow(_trackingPoint, FlxCamera.STYLE_LOCKON);
			FlxG.addCamera(Camera);
			
			_jumpTimer = new FlxTimer();
			
			Bombs = new FlxGroup(1);
		}
	
		override public function update():void 
		{
			//Camera tracking point
			_trackingPoint.x = this.x + 175;
			_trackingPoint.y = this.y - 150;
			
			//Only accelerate if we are touching the ground
			acceleration.x = 0;
			if (this.isTouching(FLOOR) && !IsBraking)
			{
				acceleration.x = 70;
			}
			
			//Jump
						
			if (this.isTouching(FLOOR))
			{
				IsJumping = false;
				JumpKeyReleased = true; 
				_jumpTimer = new FlxTimer();
				_lastJumpTimerProgress = 0;
			}
			else { IsJumping = true; }
			
			if (_jumpTimer.finished)
			{
				JumpKeyReleased = true; 
				_jumpTimer = new FlxTimer();
				_lastJumpTimerProgress = 0;
			}
			
			if (FlxG.keys.X && !IsJumping && JumpKeyReleased)
			{
				JumpKeyReleased = false;
				IsJumping = true;
				_jumpTimer.start(.5);
			}
			else if(!FlxG.keys.X && IsJumping && !JumpKeyReleased)
			{ 
				JumpKeyReleased = true; 
				_jumpTimer = new FlxTimer();
				_lastJumpTimerProgress = 0;
			}
			
			if (IsJumping && !JumpKeyReleased)
			{
				if (_jumpTimer.progress == 0) velocity.y -= 20;
				else if (_jumpTimer.progress <= 1)
				{
					velocity.y -= MAXJUMPHEIGHT * int((_jumpTimer.progress - _lastJumpTimerProgress)*100)/100;
					_lastJumpTimerProgress = _jumpTimer.progress;	
				}
				else
				{
					trace("Timer done");
				}
			}
			
			//Braking
			if (FlxG.keys.C)
			{
				if (this.isTouching(FLOOR))
				{
					acceleration.x = 0;
					velocity.x *= .95;
				
					if (velocity.x < MINBRAKESPEED)
					{
						velocity.x = MINBRAKESPEED;
					}
				
					IsBraking = true;
					return;
				}
			}
			else { IsBraking = false; }
			
			//Fire bombs
			if (Bombs.getFirstAlive() == null && FlxG.keys.justPressed("SPACE"))
			{
				testFireBomb();
			}
			else if (Bombs.getFirstAlive() != null && FlxG.keys.justPressed("SPACE"))
			{
				var b:FlxBasic = Bombs.getFirstAlive();
				if (b != null)
				{
					b.kill();				
					Bombs.remove(b);
				}
			}
			
			//Change world bounds to keep collisions working
			FlxG.worldBounds = new FlxRect(x - 40, y - 40, Camera.width, Camera.height);
			super.update();
		}
		
		public function fireBomb()
		{
			var playerPosition:FlxPoint = new FlxPoint();
				playerPosition.x = this.x + this.width / 2;
				playerPosition.y = this.y + this.height / 2;
				
				var mousePosition:FlxPoint = new FlxPoint(FlxG.mouse.screenX + Camera.x, FlxG.mouse.screenY + Camera.y);
				
				//normalize the vector
				var distance:FlxPoint = new FlxPoint(mousePosition.x - playerPosition.y, mousePosition.y - playerPosition.y);
				
				var hold:Number = Math.abs(distance.x ^ 2 + distance.y ^ 2);
				var length:Number = Math.sqrt(hold);
				var normal:FlxPoint = new FlxPoint(distance.x/length, distance.y/length);
				
				Bombs.add(new Bomb(playerPosition.x, playerPosition.y, normal.x * BOMBTHROWSPEED, normal.y * BOMBTHROWSPEED));
		}
		
		public function testFireBomb()
		{
			
			var playerPosition:FlxPoint = new FlxPoint();
			playerPosition.x = this.x + this.width / 2;
			playerPosition.y = this.y + this.height / 2;
				
			var mousePosition:FlxPoint = new FlxPoint(FlxG.mouse.screenX + Camera.x, FlxG.mouse.screenY + Camera.y);
				
			//normalize the vector
			var distance:FlxPoint = new FlxPoint(mousePosition.x - playerPosition.y, mousePosition.y - playerPosition.y);
		
			var aimangle:Number = FlxU.getAngle(new FlxPoint(0, 0), distance);
			var fireangle:Number = aimangle * (Math.PI / 180);
			
			Bombs.add(new Bomb(playerPosition.x, playerPosition.y, Math.cos(fireangle), Math.sin(fireangle)));
		}
	}
}