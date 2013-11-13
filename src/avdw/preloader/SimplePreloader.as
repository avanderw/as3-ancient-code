package avdw.preloader {
	import avdw.decorator.background.RadialGradientBackground;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.ime.CompositionAttributeRange;
	import flash.text.TextField;
	import utils.textField.createField;
	
	public class SimplePreloader extends MovieClip {
		private var simulate:Boolean;
		private var step:Number;
		private var glowCircle:Sprite;
		private var _mask:Sprite;
		private var greenBar:Sprite;
		private var percentage:TextField;
		private var barBg:Sprite;
		private var textfield:TextField;
		
		public function SimplePreloader(simulate:Boolean = false) {
			this.simulate = simulate;
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			step = stage.stageWidth / 200;
			var height:int = 5;
			barBg = new Sprite();
			barBg.graphics.beginFill(0x0);
			barBg.graphics.drawRect(0, 0, stage.stageWidth / 2, height);
			barBg.graphics.endFill();
			barBg.filters = [new DropShadowFilter(3)];
			barBg.x = stage.stageWidth / 4;
			barBg.y = (stage.stageHeight - height) / 2;
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(stage.stageWidth, stage.stageHeight, 0, -stage.stageWidth / 4, -stage.stageHeight / 2);
			greenBar = new Sprite();
			greenBar.graphics.beginGradientFill(GradientType.RADIAL, [0x009900, 0x459945], [1, 1], [0, 255], matrix);
			greenBar.graphics.drawRect(0, 0, stage.stageWidth / 2 - 2, height - 2);
			greenBar.graphics.endFill();
			greenBar.x = barBg.x + 1;
			greenBar.y = barBg.y + 1;
			
			glowCircle = new Sprite();
			glowCircle.graphics.beginFill(0x009900);
			glowCircle.graphics.drawCircle(0, 0, 12);
			glowCircle.graphics.endFill();
			glowCircle.scaleX = glowCircle.scaleY = 0.5;
			glowCircle.x = greenBar.x;
			glowCircle.y = greenBar.y + 1;
			glowCircle.filters = [new BlurFilter(8, 8)];
			
			_mask = new Sprite();
			_mask.graphics.beginFill(0xFFFFFF);
			_mask.graphics.drawRect(0, 0, stage.stageWidth / 2 - 2, height - 2);
			_mask.graphics.endFill();
			_mask.x = greenBar.x - _mask.width;
			_mask.y = greenBar.y + 1;
			greenBar.mask = _mask;
			
			var glowFilter:GlowFilter = new GlowFilter(0x0, 1, 2, 2, 6);
			textfield = createField("Loading:", 0, 0, 200, 20, false, "Verdana", 12, 0x009900);
			textfield.filters = [glowFilter];
			textfield.x = barBg.x;
			textfield.y = barBg.y - 25;
			
			percentage = createField("0%", 0, 0, 200, 20, false, "Verdana", 12, 0x009900);
			percentage.filters = [glowFilter];
			percentage.x = textfield.x + textfield.width;
			percentage.y = textfield.y;
			
			if (simulate) {
				addEventListener(ProgressEvent.PROGRESS, progress);
			} else {
				addEventListener(Event.ENTER_FRAME, checkFrame);
				loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			}
			
			addChild(barBg);
			addChild(greenBar);
			addChild(_mask);
			addChild(glowCircle);
			addChild(textfield);
			addChild(percentage);
			RadialGradientBackground.addTo(stage);
		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void {
			trace("progress", e.bytesLoaded, e.bytesTotal, Math.round(e.bytesLoaded * 100 / e.bytesTotal) + "%");
			
			if (simulate && e.bytesLoaded == e.bytesTotal) {
				loadingFinished();
			} else {
				glowCircle.x += step;
				_mask.x += step;	
			}
			percentage.text = Math.round(e.bytesLoaded * 100 / e.bytesTotal) + "%";
		}
		
		private function checkFrame(e:Event):void {
			trace("checkFrame");
			if (currentFrame == totalFrames) {
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void {
			trace("loadingFinished");
			
			if (simulate) {
				removeEventListener(ProgressEvent.PROGRESS, progress);
			} else {
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			}
			
			removeChild(barBg);
			removeChild(greenBar);
			removeChild(_mask);
			removeChild(glowCircle);
			removeChild(textfield);
			removeChild(percentage);
			RadialGradientBackground.removeFrom(stage);
			
			if (!simulate) {
				startup();
			}
		}
		
		protected function startup():void {
			addChild(new Main() as DisplayObject);
		}
	}
}