package  
{	
	public class Asteroid extends Entity
	{
		public static const TYPE_BIG:String = "typeBig";
		public static const TYPE_MEDIUM:String = "typeMedium";
		public static const TYPE_SMALL:String = "typeSmall";
		public static const ON_ASTEROID_BREAK:String = "onAsteroidBreak";
		public var _type:String = Asteroid.TYPE_BIG;
		private const _standardSize:Number = 12.5;		
		
		public function Asteroid(x:Number, y:Number, type:String) 
		{
			super(x, y);
			_type = type;
			var sf:Number = getScaleFactor(type);
			_radius = Math.round(_standardSize / sf);
			_vx = Utils.getRandom(-3,3) * sf;
			_vy = Utils.getRandom(-3,3) * sf;
			_vr = Utils.getRandom(-5,5) * sf;
			draw();
		}
		
		override public function onCollision(e:Entity):void
		{
			super.onCollision(e);
			dispatchEvent(new AsteroidBreakEvent(Asteroid.ON_ASTEROID_BREAK, x, y, _type));
		}
		
		private function getScaleFactor(type:String):Number
		{
			var sf:Number = 1;
			if(type == Asteroid.TYPE_BIG)
			{
				sf = 0.20;
			}
			else if(type == Asteroid.TYPE_MEDIUM)
			{
				sf = 0.40;
			}
			else
			{
				sf = 0.95;
			}
			return sf;
		}
		
		override public function draw():void
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.drawCircle(0, 0, _radius);
		}
	}
}
