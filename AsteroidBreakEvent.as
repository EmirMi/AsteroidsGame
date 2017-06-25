package  
{
	import flash.events.Event;
	
	public class AsteroidBreakEvent extends Event
	{
		public var _x:Number = 0;
		public var _y:Number = 0;
		public var _type:String = "";
		
		public function AsteroidBreakEvent(type:String, x:Number, y:Number, asteroidType:String) 
		{
			super(type);
			_x = x;
			_y = y;
			_type = asteroidType;
		}
	}
}

