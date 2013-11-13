package avdw.math.noise {
	import avdw.math.noise.generator.CBillow2D;
	import avdw.math.noise.generator.CRidgedMulti2D;
	import avdw.math.noise.generator.IGenerator2D;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 * @version 1
	 */
	[SWF(width="512",height="512",backgroundColor="0x0",frameRate="30")]
	
	public class Main extends Sprite {
		private var bitmapData:BitmapData;
		private var lastRow:int, lastCol:int;
		private var noise:IGenerator2D;
		
		public function Main() {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			noise = new CBillow2D();
			noise.frequency = 1;
			noise.lacunarity = 2;
			noise.ocaves = 6;
			noise.persistence = 0.5;
			noise.seed = Math.random() * 0xFFFF;
			noise.offset = 1;
			noise.gain = 2;
			noise.exponent = 1;
			
			bitmapData = new BitmapData(256, 256);
			
			addChild(new Bitmap(bitmapData));
			
			lastRow = lastCol = 0;
			addEventListener(Event.ENTER_FRAME, animate);
		}
		
		private function animate(e:Event):void {
			var isBroken:Boolean = false;
			if (lastRow < stage.stageHeight) {
				bitmapData.lock();
				var startTime:Number = new Date().getTime();
				for (var row:int = lastRow; row < 256; row++) {
					for (var col:int = lastCol; col < 256; col++) {
						var num:Number = (noise.value(row / 255, col / 255) + 1) / 2 * 0xff;
						var color:uint = num & 0xFF;
						color = color << 16 | color << 8 | color;
						bitmapData.setPixel(col, row, color);
						lastCol = (col + 1) & (255);
						if (new Date().getTime() - startTime > 33.3333) {
							isBroken = true;
							break;
						}
					}
					lastRow = row;
					if (isBroken) {
						break;
					}
				}
				bitmapData.unlock();
			}
		
		}
	}

}