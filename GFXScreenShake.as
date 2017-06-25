package  
{
	
	public class GFXScreenShake extends GFX 
	{
		
		public function GFXScreenShake(x:Number, y:Number) 
		{
			super(0, 0);
		}
		
		override public function update():void
		{
			this.alpha *= 0.8;
			if(this.alpha <= 0)
			{
				this.visible = false;
				_isAlive = false;
			}
		}
	}
}
