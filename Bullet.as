package  
{	
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	
	public class Bullet extends Entity
	{
		private var _timeToLive:Number = 120;
		
		public function Bullet(x:Number, y:Number, direction:Number) 
		{
			super(x, y);			
			_thrust = 4;
			_radius = 2;
			var angle:Number = direction * Utils.TO_RAD;
			_vx = Math.cos(angle) * _thrust;
			_vy = Math.sin(angle) * _thrust;
			draw();
		}
		
		override public function update():void
		{
			super.update();
			if(_timeToLive-- < 0)
			{
				_isAlive = false;
			}
		}
		
		override public function draw():void
		{
			graphics.clear();
			graphics.lineStyle(_radius*2, 0xFF3300, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
			graphics.lineTo(0.13, 0);
		}
	}
}
