package  
{
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	
	public class PowerUps extends Entity
	{
		private var _timeToLive:int = 360;
		
		public function PowerUps(x:Number, y:Number, direction:Number) 
		{
			super(x, y);
			_radius = 10;			
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
		override public function onCollision(e:Entity):void
		{
			_isAlive = false;
		}
		
		override public function draw():void
		{
			super.draw();
			graphics.lineStyle(_radius*2, 0x009900, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
			graphics.lineTo(0.13, 0);
		}
	}
}

