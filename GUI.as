package 
{
	import flash.text.TextField;
	
	public class GUI extends Entity
	{
		static var _pointsField:TextField;
		static var _livesLeft:TextField;
		static var _level:TextField;
		static var _missilesLeft:TextField;
		static var _shield:TextField;
		static var _powerUp:TextField;
		
		public function GUI(x:Number, y:Number) 
		{
			super(x, y);
			_pointsField = text1;
			_level = text2;
			_livesLeft = text3;
			_missilesLeft = text4;
			_shield = text5;
			_powerUp = text6;
		}
		
		override public function update():void
		{

		}
		
		public static function tick():void
		{
			_pointsField.text = "Points: " + Main._points;
			_level.text = "Level " + ((Main._currentLevelNum)+1);
			_livesLeft.text = "Lives left: " + Main._shipLives;
			_missilesLeft.text = "Missiles left: " + Ship._missileMax;
			_shield.text = "Shieldtime: " + Math.round((Ship._countDown)/60) + " s";
			_powerUp.text = "Lifes to get: " + Main._powerUps;
		}
	}
}

