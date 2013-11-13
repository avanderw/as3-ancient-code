package avdw.preloader {
	import com.bit101.components.ComboBox;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	//[Frame(factoryClass="avdw.preloader.SimplePreloader")]
	public class Main extends Sprite {
		private var demoPreloaders:Array = [DebugPreloader, SimplePreloader];
		private var preloader:DisplayObject;
		private var timer:Timer;
		private var count:int;
		private var preloaderComboBox:ComboBox;
		
		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			CONFIG::debug {
				addChild(createField("debug mode", stage.stageWidth - 105, stage.stageHeight - 20, 100, 20, false, "Verdana", 9, 0xFF0000, TextFieldAutoSize.RIGHT));
				MonsterDebugger.initialize(this);
			}
			
			var controls:Sprite = new Sprite();
			controls.graphics.beginFill(0);
			controls.graphics.drawRect(0, 0, 680, 25);
			controls.graphics.endFill();
			preloaderComboBox = new ComboBox(controls, 5, 2, "select...", demoPreloaders);
			preloaderComboBox.width = 140;
			preloaderComboBox.selectedIndex = 0;
			new PushButton(controls, 150, 2, "simulate", start);
			stage.addChild(controls);
			
			timer = new Timer(25, 100);
			timer.addEventListener(TimerEvent.TIMER, progress);
		}
		
		private function start(e:MouseEvent):void {
			trace("start");
			if (getChildByName("preloader") != null)
				removeChild(preloader as DisplayObject);
			preloader = new preloaderComboBox.selectedItem(true);
			(preloader as DisplayObject).name = "preloader";
			addChild(preloader as DisplayObject);
			
			timer.stop();
			count = 0;
			timer.reset();
			timer.start();
		}
		
		private function progress(e:Event):void {
			trace("progress");
			count++;
			var progressEvent:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			progressEvent.bytesLoaded = count;
			progressEvent.bytesTotal = 100;
			
			(preloader as EventDispatcher).dispatchEvent(progressEvent);
		}
	
	}

}