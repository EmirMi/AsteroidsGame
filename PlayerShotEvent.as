package  
{
	import flash.events.Event;
	
	public class PlayerShotEvent extends Event
	{
		public var _x:Number = 0;
		public var _y:Number = 0;
		public var _direction:Number = 0;
		
		public function PlayerShotEvent(type:String, x:Number, y:Number, direction:Number) 
		{
			super(type);
			_x = x;
			_y = y;
			_direction = direction;	
		}
	}
}
