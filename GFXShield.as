package  
{
	public class GFXShield extends GFX 
	{
		private var _scaleFactor:Number = 1;
		
		public function GFXShield(x:Number, y:Number, sf:Number = 1)
		{
			super(x, y);
			_scaleFactor = sf;
			this.scaleX *= _scaleFactor;
			this.scaleY *= _scaleFactor;
			graphics.beginFill(0xFFFF00);
			graphics.drawCircle(0, 0, 8);
			graphics.endFill();
			this.alpha = 0.4;
		}
	}
}