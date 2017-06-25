package  
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	public class Key 
	{
		private static var _keys:Object = {};
		private static var _initialized:Boolean = false;
		
		public static const ACCELERATE:uint = Keyboard.UP;
		public static const BREAK:uint = Keyboard.DOWN;
		public static const LEFT:uint = Keyboard.LEFT;
		public static const RIGHT:uint = Keyboard.RIGHT;
		public static const SHOOT:uint = Keyboard.SPACE;
		public static const TELEPORT:uint = Keyboard.T;
		public static const SHIELD:uint = Keyboard.S;
		public static const MISSILE:uint = Keyboard.M;
		
		public static function init(s:Stage):void
		{
			if(!_initialized)
			{
				s.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
				s.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
				s.addEventListener(Event.DEACTIVATE, onDeactivate);
				_initialized = true;
			}
		}
		
		public static function isDown(keyCode:uint):Boolean
		{
			return (keyCode in _keys);
		}
		
		private static function onKeyPress(e:KeyboardEvent):void
		{
			_keys[e.keyCode] = true;
		}
		
		private static function onKeyRelease(e:KeyboardEvent):void
		{
			if(e.keyCode in _keys)
			{
				delete _keys[e.keyCode];
			}
		}
		
		private static function onDeactivate(e:Event):void
		{
			_keys = {};
		}
		
		public function Key() 
		{
			throw new Error("Never instantiate Key!");
		}
	}
}
