package  
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class Entity extends Sprite
	{
		protected var _thrust:Number = 0;	
		protected var _vx:Number = 0;
		protected var _vy:Number = 0;
		protected var _vr:Number = 0;
		protected var _color:uint = 0xFFFFFF; 
		protected var _radius:Number = 0;
		public var _isAlive:Boolean = true;
		
		public function Entity(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
		}

		public function update():void
 		{
			this.x += _vx;
			this.y += _vy;
			this.rotation += _vr;
		}
		
		public function draw():void
		{
			graphics.clear();
		}
		
		public function onCollision(e:Entity):void
		{
			Sprite(parent).graphics.lineStyle(1, 0xFF00FF, 0.7);			
			Sprite(parent).graphics.drawCircle(this.x, this.y, _radius);
			_isAlive = false;
		}
		
		public function isColliding(that:Entity):Boolean
		{
			var dx:Number = this.x - that.x;
			var dy:Number = this.y - that.y;
			var distance:Number = Math.sqrt(dx*dx + dy*dy);
			return(distance < this.radius + that.radius);
		}
		
		
		public function get radius():Number		{ return _radius 	}
		public function set radius(r:Number) 	{ _radius = r;	 	}
		public function get vx():Number			{ return _vx 		}
		public function set vx(vx:Number) 		{ _vx = vx;	 		}
		public function get vy():Number			{ return _vy 		}
		public function set vy(vy:Number) 		{ _vy = vy;	 		}
		public function get color():Number		{ return _color; 	}
		public function set color(c:Number) 	{ _color = c;	 	}
	}
	
}

