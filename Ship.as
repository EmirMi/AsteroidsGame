package  
{	
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;	
	import flash.geom.Point;

	public class Ship extends Entity
	{
		public var _config:Config = null;	
		public static const PLAYER_SHOT:String = "playerShot";
		public static const MISSILE_SHOT:String = "playerMissile";
		private var _h:int = 15;
		private var _w:int = 25;
		private var _nose:Point = new Point(_w*0.5, 0);
		private var _rearRight:Point = new Point(-_w*0.5, _h*0.5);
		private var _engineHole:Point = new Point(-_w*0.4, 0);
		private var _rearLeft:Point = new Point(-_w*0.5, -_h*0.5);
		private var _timeBetweenShot:int;
		private var _lastShot:int = getTimer();
		private var _timeBetweenMissiles:int;
		private var _lastMissile:int = getTimer();
		public static var _missileMax:Number = 3;
		private var _timeBetweenTeleports:int;
		private var _lastTeleport:int = getTimer();
		private var _shield:GFXShield = new GFXShield(0, 0, 1.9);
		public var _shieldOn:Boolean = false; 
		public var _shieldUsed:Boolean = false; 
		private var _myTimer:Timer; 
		public static var _countDown:Number = 1200;
		private var _friction:Number = 0.99;
		
		
		public function Ship(x:Number, y:Number) 
		{
			super(x, y);
			draw();
			_radius = (height + width)*0.25;
			this.addChild(_shield);
			_shield.visible = false;
			_config = new Config();
		}
		
		override public function update():void	
		{
			_timeBetweenShot = _config._timebShot;
			_timeBetweenMissiles = _config._timeMissiles;
			_timeBetweenTeleports =  _config._timeTeleports;
			readInput();
			var ax:Number = 0;
			var ay:Number = 0;
			if(_thrust)
			{
				var angle:Number = this.rotation * Utils.TO_RAD;
				ax = Math.cos(angle) * _thrust;
				ay = Math.sin(angle) * _thrust;
			}
			_vx += ax;
			_vy += ay;
			_vx *= _friction;
			_vy *= _friction;
			super.update();
			draw();
			if(_thrust)
			{
				drawFlame();
			}
		}

		private function readInput():void
		{
			
			if(Key.isDown(Key.SHOOT))
			{
				if(getTimer()-_lastShot > _timeBetweenShot)
				{
					var angle:Number = this.rotation * Utils.TO_RAD;
					var bx:Number = Math.cos(angle) * _radius;
					var by:Number = Math.sin(angle) * _radius;	
					dispatchEvent(new PlayerShotEvent(Ship.PLAYER_SHOT, x+bx, y+by, rotation));
					_lastShot = getTimer();
				}
			}
			
			if(Key.isDown(Key.ACCELERATE))
			{
				_thrust = 0.2;
			}
			else 
			{
				_thrust = 0;
			}
			if(Key.isDown(Key.LEFT))
			{
				_vr = -4;
			}
			else if(Key.isDown(Key.RIGHT))
			{
				_vr = 4;
			}
			else
			{
				_vr = 0
			}
			if(Key.isDown(Key.TELEPORT))
			{
				if(getTimer()- _lastTeleport > _timeBetweenTeleports)
					{
						x = Utils.getRandom(0, stage.stageWidth);
						y = Utils.getRandom(0, stage.stageHeight);
						_lastTeleport = getTimer();
					}
			}
			
			if(Key.isDown(Key.MISSILE))
			{
				if(getTimer()-_lastMissile > _timeBetweenMissiles && _missileMax > 0)
				{
					angle = rotation * Utils.TO_RAD;
					bx = Math.cos(angle) * _radius;
					by = Math.sin(angle) * _radius;
					dispatchEvent(new MissileShotEvent(Ship.MISSILE_SHOT, x+bx, y+by, rotation));
					_lastMissile = getTimer();
				}
			}
			
			if (Key.isDown(Key.SHIELD))
			{
				if(!_shieldUsed == true)
				{
					_shieldOn = true;
					_shield.visible = true;
					_myTimer = new Timer(_countDown, 1);
					_myTimer.addEventListener(TimerEvent.TIMER, deactivateShield, false, 0, true);
					_myTimer.start();
				}
			}
			else
			{
				_shield.visible = false;
				_shieldOn = false;
			}
		}
		
		override public function isColliding(that:Entity):Boolean
		{
			var isMaybeColliding:Boolean = super.isColliding(that);
			if(!isMaybeColliding)
			{
				return false;
			}
			var stageNose:Point = localToGlobal(_nose);
			var stageLeft:Point = localToGlobal(_rearLeft);
			var stageRight:Point = localToGlobal(_rearRight);
			
			var leftCollide:Boolean = lineCircleIntersection(stageNose, stageLeft, that);
			var rightCollide:Boolean = lineCircleIntersection(stageNose, stageRight, that);
			return leftCollide || rightCollide;
			
		}
		
		private function lineCircleIntersection(p1:Point, p2:Point, e:Entity):Boolean
		{
			var angle:Number = Math.atan2((p2.y-p1.y),(p2.x-p1.x));
			var dx:Number = e.x-((p1.x+p2.x)*0.5);
			var dy:Number = e.y-((p1.y+p2.y)*0.5);
			return(Math.abs(Math.cos(angle)*dy - Math.sin(angle)*dx) < e.radius);
		}
		
		override public function draw():void
		{
			super.draw();
			graphics.beginFill(0x0000FF);
			graphics.lineStyle(2, 0x0000FF);
			graphics.moveTo(_nose.x, _nose.y);
			graphics.lineTo(_rearRight.x, _rearRight.y);
			graphics.lineTo(_engineHole.x, _engineHole.y);
			graphics.lineTo(_rearLeft.x, _rearLeft.y);
			graphics.lineTo(_nose.x, _nose.y);
		}
		
		private function drawFlame():void
		{
			var l:Number = Utils.getRandom(4, 11);
			var h:Number = 15;
			var w:Number = 20;
			graphics.beginFill(0xFF0000);
			graphics.lineStyle(1, 0xFF0000);
			graphics.moveTo(-w*0.5, -h*0.4);
			graphics.lineTo((-w*0.5)-l, 0);
			graphics.lineTo(-w*0.5, h*0.5);
		}
				
		public function deactivateShield(e:TimerEvent):void 
		{
			_countDown--;
			if(_countDown == 0)
			{
				_myTimer.stop();
				_shieldUsed = true;
				_shieldOn = false;
				_shield.visible = false;
			}
        }
	}
}
		