package avdw.lsystem {
	import avdw.math.vector2d.Vec2;
	import avdw.math.vector2d.Vec2Const;
	import de.polygonal.ds.LinkedStack;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import utils.conversion.degreesToRadians;
	
	public class LSystemPainter {
		static public const DRAW:int = 0;
		static public const ROTATE_LEFT:int = 1;
		static public const ROTATE_RIGHT:int = 2;
		static public const STATE_SAVE:int = 3;
		static public const STATE_RESTORE:int = 4;
		static public const DO_NOTHING:int = 5;
		
		protected const pen:Vec2 = new Vec2();
		protected const line:Vec2 = new Vec2(0, 1);
		protected const stack:LinkedStack = new LinkedStack();
		
		protected var angle:Number;
		protected var g:Graphics;
		
		public var label:String = "Basic Painter";
		
		public function LSystemPainter(lineLength:Number = 1, rotateAngleDegrees:Number = 90) {
			setup(lineLength, rotateAngleDegrees);
		}
		
		public function setup(lineLength:Number, rotateAngleDegrees:Number):void {
			pen.zero();
			line.zero();
			line.addSelf(new Vec2Const(0, 1));
			line.rotateSelf(Math.PI);
			line.scaleSelf(lineLength);
			angle = degreesToRadians(rotateAngleDegrees);
		}
		
		public function paint(system:LSystem, sprite:Sprite = null):Sprite {
			if (sprite == null)
				sprite = new Sprite();
			
			g = sprite.graphics;
			g.lineStyle(1);
			
			var action:String;
			var actions:Array = system.expansion.split("");
			for each (action in actions) {
				doAction(system, action);
			}
			
			return sprite;
		}
		
		protected function doAction(system:LSystem, action:String):void {
			var data:Object;
			switch (system.grammar.actions[action]) {
				case DRAW: 
					g.moveTo(pen.x, pen.y);
					pen.addSelf(line);
					g.lineTo(pen.x, pen.y);
					break;
				case ROTATE_LEFT: 
					line.rotateSelf(angle);
					break;
				case ROTATE_RIGHT: 
					line.rotateSelf(-angle);
					break;
				case STATE_SAVE: 
					data = new Object();
					data.pen = new Vec2(pen.x, pen.y);
					data.line = new Vec2(line.x, line.y);
					data.angle = new Number(angle);
					stack.push(data);
					break;
				case STATE_RESTORE: 
					data = stack.pop();
					pen.x = data.pen.x;
					pen.y = data.pen.y;
					line.x = data.line.x;
					line.y = data.line.y;
					angle = data.angle;
					break;
				case DO_NOTHING: 
					break;
				default: 
					trace(action + " :command not implemented");
			}
		}
	}

}