package avdw.preloader {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class DebugPreloader extends MovieClip {
		private var simulate:Boolean;
		
		public function DebugPreloader(simulate:Boolean = false) {
			this.simulate = simulate;
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			if (simulate) {
				addEventListener(Event.ADDED_TO_STAGE, init);
			} else {
				addEventListener(Event.ENTER_FRAME, checkFrame);
				loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			}
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(ProgressEvent.PROGRESS, progress);
		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void {
			trace("progress", e.bytesLoaded, e.bytesTotal, Math.round(e.bytesLoaded * 100 / e.bytesTotal) + "%");
			
			if (simulate && e.bytesLoaded == e.bytesTotal) {
				loadingFinished();
			}
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
			
			// TODO hide loader
			
			if (!simulate) {
				startup();
			}
		}
		
		private function startup():void {
			addChild(new Main() as DisplayObject);
		}
	}

}