package  
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;	
	import flash.text.TextField;
	import flash.net.URLLoader;
	import flash.net.XMLSocket;
	import flash.net.URLRequest;
	
	public class Main extends Sprite 
	{
		private var _surface:Graphics = null;
		public var _config:Config = null;
		private var _asteroids:Array = [];
		private var _bullets:Array = [];
		private var _missiles:Array = [];
		private var _gfx:Array = [];
		private var _powerups:Array = [];
		private var _ship:Ship = null;
		public static const GAME_OVER: String = "gameOver";
		public var MAX_BULLETS:int;
		public var MAX_MISSILES:int;
		public static var _powerUps:int = 3;
		public static var _shipLives:int = 10;
		public static var _points:int = 0;
		private var _onPause:Boolean = false;
		private var _level1 = new Array(Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM);
		private var _level2 = new Array(Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM);
		private var _level3 = new Array(Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_BIG, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_MEDIUM, Asteroid.TYPE_SMALL, Asteroid.TYPE_SMALL, Asteroid.TYPE_SMALL, Asteroid.TYPE_SMALL, Asteroid.TYPE_SMALL);
		private var _currentLevel = new Array(_level1, _level2, _level3);
		public static var _currentLevelNum:int = 0;
		private var _myTimer:Timer = null; 
		private var _randomTimerStart:int = 1000 * Utils.getRandom(1, 20);
		
		public function Main() 
		{
			_surface = graphics;
			_config = new Config();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.ENTER_FRAME, update);
			_surface.beginFill(0x000000);
			_surface.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_surface.endFill();
			Key.init(stage);
			_ship = new Ship(stage.stageWidth*0.5, stage.stageHeight*0.5);
			_ship.addEventListener(Ship.PLAYER_SHOT, onPlayerShot);
			_ship.addEventListener(Ship.MISSILE_SHOT, onMissileShot);
			_shipLives = 10;
			addEntity(_ship);
			stage.addChild((new GUI(0, 0)));
			addAsteroids();	
			_myTimer = new Timer(_randomTimerStart);
			_myTimer.addEventListener(TimerEvent.TIMER, lifeUp);
			_myTimer.start();
		}
		
		private function addAsteroids():void
		{
			for(var i:Number = 0; i < _currentLevel[_currentLevelNum].length; i++)
			{
				var buffer:Number = _ship.radius+100;
				var xpos:Number = Utils.getRandom(_ship.x+buffer, stage.stageWidth);
				if(Math.random() < 0.5)
				{
					xpos = Utils.getRandom(0, _ship.x-buffer);
				}
				var ypos:Number = Utils.getRandom(0, stage.stageHeight);
				var a:Asteroid = new Asteroid(xpos, ypos, _level1[i]);
				addEntity(a);
			}
		}
				
		public function update(e:Event):void
		{
			var allThings:Array = _asteroids.concat(_bullets, _gfx, _ship, _missiles, _powerups);
			for(var i:Number = 0; i < allThings.length; i++)
			{
				var temp:Entity = allThings[i];
				temp.update();
				boundaryCheck(temp);	
			}
			MAX_BULLETS = _config._maxBullets;
			MAX_MISSILES = _config._maxMissiles;
			GUI.tick();
			collisionChecks();
			removeDeadEntities(_bullets);
			removeDeadEntities(_missiles);
			removeDeadEntities(_asteroids);
			removeDeadEntities(_gfx);
			removeDeadEntities(_powerups);
		}
		
		private function collisionChecks():void
		{
			for(var i:Number = 0; i < _asteroids.length; i++)
			{
				var a:Asteroid = _asteroids[i];
				for(var j:Number = 0; j < _bullets.length; j++)
				{
					var b:Bullet = _bullets[j];
					if(b._isAlive && b.isColliding(a))
					{
						addEntity(new GFXBoom(b.x, b.y));
						b.onCollision(a);
						a.onCollision(b);
						SoundManager.play("explosion");
						if(_points >= 400 && _currentLevelNum == 0)
						{
							_currentLevelNum = 1;
							addAsteroids();
							SoundManager.play("levelup");
							
						}
						else if(_points >= 800 && _currentLevelNum == 1)
						{
							_currentLevelNum = 2;
							addAsteroids();
							SoundManager.play("levelup");
						}
						break;
					}
				}
				for(var k:Number = 0; k < _missiles.length; k++)
				{
					var m:Missile = _missiles[k];
					if(m._isAlive && m.isColliding(a))
					{
						addEntity(new GFXBoom(m.x, m.y));
						m.onCollision(a);
						a.onCollision(m);
						SoundManager.play("explosion");
						if(_points >= 400 && _currentLevelNum == 0)
						{
							_currentLevelNum 1;
							addAsteroids();
							SoundManager.play("levelup");
						}
						else if(_points >= 800 && _currentLevelNum == 1)
						{
							_currentLevelNum 2;
							addAsteroids();
							SoundManager.play("levelup");
						}
						break;
					}
				}
				if(!_ship._shieldOn)
				{
					if(_ship.isColliding(a))
					{
						a.onCollision(_ship);
						_ship.onCollision(a);
						_shipLives--;
						if(_shipLives <= 0)
						{
							gameOver();
						}
						addEntity(new GFXOuch(_ship.x, _ship.y));
						addEntity(new GFXScreenShake(0, 0)); 
						SoundManager.play("collision");
					}
				}
			}
			for(var l:Number = 0; l < _powerups.length; l++)
			{
				var p:PowerUps = _powerups[l];
				if(_ship.isColliding(p))
				{
					_shipLives ++;
					p.onCollision(_ship);
					addEntity(new GFXLife(_ship.x, _ship.y)); 
					SoundManager.play("levelup");
				}
			}
		}
		
		private function removeDeadEntities(entityList:Array):void
		{
			for(var i:Number = entityList.length-1; i>=0; i--)
			{
				var temp:Entity = entityList[i];
				if(!temp._isAlive)
				{
					removeChild(temp);
					entityList.splice(i, 1);
				}	
			}
		}
		
		public function gameOver():void
		{
			dispatchEvent(new Event(Main.GAME_OVER));	
			resetAll();
		}
		
		public function resetAll():void
		{
			_points = 0;
			Ship._missileMax = 3;
			_currentLevelNum = 0;
			_shipLives = 10;
			Ship._countDown = 1200;
			_powerUps = 3;
		}
		
		public function cleanUp():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, update);
			_myTimer.removeEventListener(TimerEvent.TIMER, lifeUp);
			_ship.removeEventListener(Ship.PLAYER_SHOT, onPlayerShot);
			_ship.removeEventListener(Ship.MISSILE_SHOT, onMissileShot);
		}
		
		public function boundaryCheck(e:Entity):void
		{
			var left:Number = -e.width*0.5;
			var top:Number = -e.height*0.5;
			var right:Number = stage.stageWidth + e.width*0.5;
			var bottom:Number = stage.stageHeight + e.height*0.5;;
			
			if(e.x < left)
			{
				e.x = right;
			}
			else if(e.x > right)
			{
				e.x = left;
			}
			
			if(e.y < top)
			{
				e.y = bottom;
			}
			else if(e.y > bottom)
			{
				e.y = top;
			}
		}
		
		private function onPlayerShot(e:PlayerShotEvent):void
		{
			if(_bullets.length >= MAX_BULLETS)
			{
				return;
			}
			addEntity(new GFXPew(e._x, e._y));
			addEntity(new Bullet(e._x, e._y, e._direction));
			SoundManager.play("laser");
		}
		
		private function onMissileShot(e:MissileShotEvent):void
		{
			if(_missiles.length >= MAX_MISSILES)
			{
				return;
			}
			if(Ship._missileMax > 0)
			{
				addEntity(new GFXPew(e._x, e._y));
				addEntity(new Missile(e._x, e._y, e._direction));
				SoundManager.play("missile");
				Ship._missileMax--;
			}			
		}
		
		private function onAsteroidBreak(e:AsteroidBreakEvent):void
		{
			var spawnCount:Number = 0;
			var newType:String = Asteroid.TYPE_MEDIUM;
			if(e._type == Asteroid.TYPE_BIG)
			{
				spawnCount = 4;
				addEntity(new GFXBoom(e._x, e._y));
				_points += 10;
			}
			else if(e._type == Asteroid.TYPE_MEDIUM)
			{
				spawnCount = 2;
				newType = Asteroid.TYPE_SMALL;
				addEntity(new GFXBoom(e._x, e._y));
				_points += 20;
			}
			else
			{
				addEntity(new GFXBoom(e._x, e._y));
				_points += 30;
			}
			while(spawnCount--)
			{
				addEntity(new Asteroid(e._x, e._y, newType));
			}
		}
		
		public function gamePause():void
		{
			if(_onPause == false)
			{
				_onPause = true;
				stage.removeEventListener(Event.ENTER_FRAME, update);
				_myTimer.stop();
			}
			else
			{
				stage.addEventListener(Event.ENTER_FRAME, update);
				_onPause = false;
				_myTimer.start();
			}
		}	
		
		private function lifeUp(e:TimerEvent):void
		{
			if(_powerUps > 0)
			{
				var x = Utils.getRandom(10, 1280);
				var y = Utils.getRandom(10, 720);
				_myTimer.delay = 1000 * Utils.getRandom(1, 20);
				addEntity(new PowerUps(x, y, 0));
				_powerUps--;
			}
		}
		
		private function addEntity(e):void
		{
			if(e is Bullet)
			{
				_bullets.push(e);
			}
			else if(e is Asteroid)
			{
				_asteroids.push(e);
				e.addEventListener(Asteroid.ON_ASTEROID_BREAK, onAsteroidBreak, false, 0, true);
			}
			else if(e is GFX)
			{
				_gfx.push(e);
			}
			else if(e is Missile)
			{
				_missiles.push(e);
			}
			else if(e is PowerUps)
			{
				_powerups.push(e);
			}
			addChild(e);
		}
	}
	
}
