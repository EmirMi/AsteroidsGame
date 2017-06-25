package  
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	
	public class GameOverState extends State 
	{
		private var _gameOver:MovieClip;		
		private var _points: Number;
		private var _scoreBoard:TextField;
		
		public function GameOverState(fsm:FSM, points:Number)
		{
			super(fsm);
			_points = points;
		}
		
		override public function enter():void
		{
			_gameOver = new GameOverBackground();
			_fsm.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			_fsm.addChild(_gameOver);
			_gameOver.x = _fsm.stage.stageWidth*0.5;
			_gameOver.y = _fsm.stage.stageHeight*0.5;
			SoundManager.play("gameover");	
			_scoreBoard = _gameOver.scoreBoard;
			_scoreBoard.text = "YOUR SCORE: " + _points + " points";
		}
		
		private function onKeyPress(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ESCAPE)
			{
				_fsm.setState(new MenuState(_fsm));
				SoundManager.stopSound();
			}
			else if(e.keyCode == Keyboard.R)
			{
				_fsm.setState(new PlayState(_fsm));
				SoundManager.stopSound();
			}
		}
		
		override public function update():void
		{
			
		}
		
		override public function exit():void
		{
			_fsm.removeChild(_gameOver);
			_gameOver = null;
			_fsm.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}
	}
}
