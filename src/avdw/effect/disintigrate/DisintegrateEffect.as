package avdw.effect.disintigrate
{
	import avdw.generate.effect.Disintegrate;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * Reference: http://wonderfl.net/c/yFSI
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	[SWF(width="465",height="465",backgroundColor="0x0",frameRate="30")]
	
	public class DisintegrateEffect extends Sprite {
		[Embed(source="../../../assets/465x465 Background.jpg")]
		private const Background:Class;
		[Embed(source="../../../assets/144x200 Assasin Creed 1.png")]
		private const Object2:Class;
		[Embed(source="../../../assets/140x200 Chris.png")]
		private const Object3:Class;
		[Embed(source="../../../assets/110x200 Noel FFXIII.png")]
		private const Object4:Class;
		
		private var txt:TextField;
		private var burnColor:uint = 0xFFFFFFFF;
		private var burnTolerance:Number = 0.6;
		private var frames:int = 200;
		private var heatTolerance:int = 40;
		private var particleMargin:int = 15;
		private var particleSpeed:Number = -1;
		private var smoothness:int = 8;
		private var speed:int = 30;
		private var twinkleAlpha:Number = 0.8;
		private var twinkleSize:int = 4;
		
		public function DisintegrateEffect() {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var bg:Bitmap = new Background();
			addChild(bg);
			txt = new TextField();
			txt.textColor = 0xFFFFFF;
			txt.autoSize = TextFieldAutoSize.LEFT;
			updateText();
			addChild(txt);
			
			var object2:Bitmap = new Object2();
			var object2Container:Sprite = new Sprite(); // needed for event registration
			object2Container.addEventListener(MouseEvent.CLICK, disintegrate);
			object2Container.addChild(object2);
			object2Container.x = Math.random() * (stage.stageWidth - object2.width);
			object2Container.y = Math.random() * (stage.stageHeight - object2.height);
			addChild(object2Container);
			
			var object3:Bitmap = new Object3();
			var object3Container:Sprite = new Sprite(); // needed for event registration
			object3Container.addEventListener(MouseEvent.CLICK, disintegrate);
			object3Container.addChild(object3);
			object3Container.x = Math.random() * (stage.stageWidth - object3.width);
			object3Container.y = Math.random() * (stage.stageHeight - object3.height);
			addChild(object3Container);
			
			var object4:Bitmap = new Object4();
			var object4Container:Sprite = new Sprite(); // needed for event registration
			object4Container.addEventListener(MouseEvent.CLICK, disintegrate);
			object4Container.addChild(object4);
			object4Container.x = Math.random() * (stage.stageWidth - object4.width);
			object4Container.y = Math.random() * (stage.stageHeight - object4.height);
			addChild(object4Container);
			
			
			
			object2Container.addEventListener(Event.COMPLETE, destroy);
			object3Container.addEventListener(Event.COMPLETE, destroy);
			object4Container.addEventListener(Event.COMPLETE, destroy);
				
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeypress);
		}
		
		private function disintegrate(e:MouseEvent):void {
			var displayObject:DisplayObject = e.target as DisplayObject;
			
			var effect:Disintegrate = new Disintegrate();
			effect
			.burnTolerance(burnTolerance)
			.heatTolerance(heatTolerance)
			.smoothness(smoothness)
			.frames(frames)
			.twinkleAlpha(twinkleAlpha)
			.disintegrate(displayObject);
		}
		
		private function destroy(e:Event):void {
			var displayObject:DisplayObject = e.target as DisplayObject;
			displayObject.x = Math.random() * (stage.stageWidth - displayObject.width);
			displayObject.y = Math.random() * (stage.stageHeight - displayObject.height);
		}
		
		private function onKeypress(e:KeyboardEvent):void {
		switch (e.keyCode) {
		case 38: // up
			heatTolerance += 10;
			break;
		case 40: // down
			heatTolerance -= 10;
			break;
		case 37: // left
			burnTolerance -= 0.1;
			break;
		case 39: // right
			burnTolerance += 0.1;
			break;
		case 190: // >
			smoothness += 1;
			break;
		case 188: // <
			smoothness -= 1;
			break;
		case 221: // ]
			frames += 10;
			break;
		case 219: // [
			frames -= 10;
			break;
		case 222: // '
			twinkleAlpha += 0.1;
			break;
		case 186: // ;
			twinkleAlpha -= 0.1;
			break;
		}
		 updateText();
		}
		
		private function updateText():void {
			txt.text = "Disintegrate Effect" + 
			"\n---------------------------------------" + 
			"\nclick a image to see it disintegrate\n" + 
			"\nburnTolerance (left/right keys):\t" + Math.round(burnTolerance*10)/10 + 
			"\nheatTolerance (up/down keys):\t" + heatTolerance + 
			"\nsmoothness ( < / > keys):\t\t" + smoothness +
			"\nframes ( [ / ] keys):\t\t\t\t" + frames + 
			"\ntwinkle ( ; / ' keys):\t\t\t\t" + Math.round(twinkleAlpha * 10) / 10;
		}
	
	}

}