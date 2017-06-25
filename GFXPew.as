package  
{
	public class GFXPew extends GFX
	{
		private const _maxSpeed:Number = 2;
		private const _minSpeed:Number = 2;
		
		public function GFXPew(x:Number, y:Number) 
		{
			super(x,y);
			_vx = Utils.getRandom(_minSpeed, _maxSpeed);
			_vy = Utils.getRandom(_minSpeed, _maxSpeed);
		}
		
		override public function update():void
		{
			super.update();
			alpha *= 0.92;
			scaleX *= 0.98;
			scaleY*= 0.98;
			if(alpha <= 0)
			{
				visible=false;
				_isAlive = false;
			}
		}
	}
	
}
