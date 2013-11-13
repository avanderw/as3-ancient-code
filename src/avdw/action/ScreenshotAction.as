package avdw.action {
	import avdw.decorator.border.SingleBorder;
	import com.adobe.images.PNGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import utils.color.averageLightness;
	import utils.textField.createField;
	
	public class ScreenshotAction {
		static private const tooltip:Sprite = new Sprite();
		static private const name:String = "ScreenshotAction";
		
		static public function addTo(stage:Stage):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, captureScreenshot);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, showKey);
			tooltip.addChild(createField("screenshot: F12", 5, 2));
			tooltip.graphics.beginFill(0xCCCCCC);
			tooltip.graphics.drawRect(0, 0, tooltip.width +10, tooltip.height + 4);
			tooltip.graphics.endFill();
			tooltip.name = name;
		}
		
		static private function captureScreenshot(e:KeyboardEvent):void {
			trace(e);
			trace(e.target, e.currentTarget);
			if (!e.ctrlKey && !e.shiftKey && e.keyCode == Keyboard.F12) {
				var display:Stage = e.currentTarget as Stage;
				var baseData:BitmapData = new BitmapData(display.stageWidth, display.stageHeight, false);
				baseData.draw(display);
				
				var ba:ByteArray = PNGEncoder.encode(baseData);
				new FileReference().save(ba, "screenshot.png");
			}
		}
		
		static private function showKey(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.BACKQUOTE) {
				if ((e.target as Stage).getChildByName(name) != null) {
					(e.target as Stage).removeChild(tooltip);
				} else {
					(e.target as Stage).addChild(tooltip);
				}
			}
		}
	}

}