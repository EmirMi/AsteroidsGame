package  
{
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.media.SoundMixer;
	
	public class SoundManager
	{
		private static var _soundExplosion:Sound = new explosion();
		private static var _soundLaser:Sound = new laser();
		private static var _soundCollision:Sound = new collision();
		private static var _soundGameOver:Sound = new gameover();
		private static var _soundIntro:Sound = new intro();
		private static var _soundLevelUp:Sound = new levelup();
		private static var _soundMissile:Sound = new missile();
		private static var _channelExplosion:SoundChannel = null;
		private static var _channelLaser:SoundChannel = null;
		private static var _channelCollision:SoundChannel = null;
		private static var _channelGameOver:SoundChannel = null;
		private static var _channelIntro:SoundChannel = null;
		private static var _channelLevelUp:SoundChannel = null;
		private static var _channelMissile:SoundChannel = null;
				
		public static function play(musicType:String):void
		{
			if(musicType == "explosion")
			{
				_channelExplosion = _soundExplosion.play();
			}
			else if(musicType == "laser")
			{
				_channelLaser = _soundLaser.play();
			}
			else if(musicType == "collision")
			{
				_channelCollision = _soundCollision.play();
			}
			else if(musicType == "levelup")
			{
				_channelLevelUp = _soundLevelUp.play();
			}
			else if(musicType == "missile")
			{
				_channelMissile = _soundMissile.play();
			}
			else if(musicType == "intro")
			{
				_channelIntro = _soundIntro.play();
			}
			else if(musicType == "gameover")
			{
				_channelGameOver = _soundGameOver.play();
			}
		}
		
		public static function stopSound():void
		{
			SoundMixer.stopAll();
		}

	}
}
