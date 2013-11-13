package avdw.lsystem {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class LSystemAnimatedPainter extends LSystemPainter {
		private var progress:int;
		private var actions:Array;
		private var fps:int;
		private var system:LSystem;
		private var sprite:Sprite;
		private var wait:int;
		
		public function LSystemAnimatedPainter(lineLength:Number = 1, rotateAngleDegrees:Number = 90, fps:int = 30) {
			super(lineLength, rotateAngleDegrees);
			label = "Animated Painter";
			wait = 1000 / fps;
		}
		
		override public function paint(system:LSystem, sprite:Sprite = null):Sprite {
			this.system = system;
			this.sprite = sprite;
			
			if (sprite == null)
				sprite = new Sprite();
			
			g = sprite.graphics;
			g.lineStyle(1);
			
			progress = 0;
			actions = system.expansion.split("");
			sprite.addEventListener(Event.ENTER_FRAME, animate);
			
			return sprite;
		}
		
		private function animate(e:Event):void {
			var startTime:int = getTimer();
			var action:String;
			while (progress < actions.length) {
				action = actions[progress];
				doAction(system, action);
				progress++;
				if (getTimer() - startTime > wait) {
					break;
				}
			}
			
			if (progress == actions.length) {
				sprite.removeEventListener(Event.ENTER_FRAME, animate);
			}
		}
	
	}

}