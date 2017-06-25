package  
{
	public class GFXBoom extends GFX
	{
		private const _maxSpeed:Number = 2;
		private const _minSpeed:Number = 2;
		
		public function GFXBoom(x:Number, y:Number) 
		{
			super(x,y);
		}
		
		override public function update():void
		{
			super.update();
			alpha *= 0.92;
			rotation += 12;
			if(alpha <= 0)
			{
				visible=false;
				_isAlive = false;
			}
		}
	}
	
}
