package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	/**
	 * ...
	 * @author Ian Rash
	 */
	class Player extends FlxSprite
	{
		private var _trackingPoint:FlxObject;
		public var Camera:FlxCamera;
		public var Explosive:Bomb;
		
		public var IsBraking:Boolean;
		
		public var IsJumping:Boolean;
		public var JumpKeyReleased:Boolean;
		private var _lastJumpTimerProgress:Number;
		
		private var _jumpTimer:FlxTimer;
		public var DeathEmitter:FlxEmitter;
		
		public const MINBRAKESPEED:int = 20;
		public const MAXJUMPHEIGHT:int = 200;
		public const BOMBTHROWSPEED:int = 100;
		public const BOMBEXPLOSIONDISTANCE:int = 50;
		public const BOMBEXPLOSIONPOWER:int = 200;
		
		
		public function Player(X:int, Y:int, state:PlayState)
		{
			super(X, Y);
			//makeGraphic(6, 12, 0xff22cc44);
			
			loadGraphic(Reg.Runner, true, false, 50, 50);
			addAnimation("run", [1, 2, 3, 4, 5, 6], 12, true);
			play("run");
			
			scale = new FlxPoint(.5, .5);
			width = 37;
			height = 37;
			
			solid = true;
			maxVelocity.x = 400;
			maxVelocity.y = 1000;
			acceleration.x = 0;
			acceleration.y = 200;
			velocity.x = 0;
			
			_trackingPoint = new FlxObject();
			
		    //Add our camera
			Camera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
			Camera.follow(_trackingPoint, FlxCamera.STYLE_LOCKON);
			FlxG.addCamera(Camera);
			
			_jumpTimer = new FlxTimer();
			
			Explosive = new Bomb(0, 0, 0, 0);
			Explosive.acceleration.y = 100;
			Explosive.kill();
			
			state.add(Explosive);
			
			DeathEmitter = new FlxEmitter(0, 0);
			DeathEmitter.gravity = 100;
			for (var i:int  = 0; i < 30; i++)
			{
				var p:FlxParticle = new FlxParticle();
				p.makeGraphic(2, 2, 0xffff0000);
				p.exists = false;
				DeathEmitter.add(p);
			}
			state.add(DeathEmitter);
		}
	
		override public function update():void 
		{
			//Camera tracking point
			_trackingPoint.x = this.x + 175;
			_trackingPoint.y = this.y - 100;
			
			//Only accelerate if we are touching the ground
			acceleration.x = 0;
			if (this.isTouching(FLOOR) && !IsBraking)
			{
				acceleration.x = 120;
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
				_jumpTimer.start(.25);
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
			
			if (FlxG.keys.V)
			{
				velocity.x = 0;
			}
			
			//Fire bombs
			if (!Explosive.alive && FlxG.keys.justPressed("SPACE"))
			{
				fireBomb();
			}
			else if (Explosive.alive && FlxG.keys.justPressed("SPACE"))
			{

				//Camera.shake();
				
				//check if the player is in the bounds of the explosion
				var distancePoint:FlxPoint = new FlxPoint((this.x + this.width / 2) - (Explosive.x + Explosive.width / 2), 														(this.y + this.height / 2) - (Explosive.y + Explosive.height / 2));
				var distance:Number = Math.abs(distancePoint.x ^ 2 - distancePoint.y ^ 2);
				
				if (distance < (BOMBEXPLOSIONDISTANCE^2))
				{
					//find out how far away we actually are
					distance = Math.sqrt(distance);
					
					var power:Number = distance / BOMBEXPLOSIONDISTANCE;
					
					distancePoint.Normalize();
					
					this.velocity.x += distancePoint.x * power * BOMBEXPLOSIONPOWER;
					this.velocity.y -= distancePoint.y * power * BOMBEXPLOSIONPOWER;
					
					//if (Math.abs(distance) < 3) this.kill();
				}
				
				Explosive.kill();
			}
			
			//Check collisions
			if ((this.isTouching(RIGHT) || this.isTouching(LEFT)))
			{				
				kill();
			}
			
			//Change world bounds to keep collisions working
			FlxG.worldBounds = new FlxRect(x - 40, y - 40, Camera.width, Camera.height);
			//Camera.setBounds(_trackingPoint.x - 40, _trackingPoint.y - 40, Camera.width, Camera.height);
			super.update();
		}
		
		public function fireBomb()
		{
			var playerPosition:FlxPoint = new FlxPoint();
			playerPosition.x = this.x + this.width / 2;
			playerPosition.y = this.y + this.height / 2;
			
			Explosive.x = playerPosition.x;
			Explosive.y = playerPosition.y;
			Explosive.velocity.x = BOMBTHROWSPEED + this.velocity.x;
			Explosive.velocity.y = -5;
			Explosive.acceleration.y = 100;
			Explosive.revive();
		}
		
		override public function kill():void 
		{
			super.kill();
			DeathEmitter.x = this.x + this.width / 2;
			DeathEmitter.y = this.y + this.height / 2;
			DeathEmitter.start(true, 10, 10, 0);
		}
	}
}