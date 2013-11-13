package avdw.action {
	import com.adobe.images.PNGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import utils.textField.createField;
	import utils.color.averageLightness;
	
	public class FeatureshotAction {
		static private const tooltip:Sprite = new Sprite();
		
		static public function addTo(stage:Stage):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, captureScreenshot);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, showKey);
			tooltip.addChild(createField("screenshot: Ctrl+F12", 105, 2));
			tooltip.graphics.beginFill(0xCCCCCC);
			tooltip.graphics.drawRect(100, 0, tooltip.width +10, tooltip.height + 4);
			tooltip.graphics.endFill();
			tooltip.name = "ScreenshotAction";
		}
		
		static private function captureScreenshot(e:KeyboardEvent):void {
			if (e.ctrlKey && !e.shiftKey && e.keyCode == Keyboard.F12) {
				var display:Stage = e.target as Stage;
				var baseData:BitmapData = new BitmapData(display.stageWidth, display.stageHeight, false);
				baseData.draw(display);
				
				var scale:Number = 0.5;
				var image:BitmapData = new BitmapData(baseData.width * scale, baseData.height * scale, false);
				var matrix:Matrix = new Matrix();
				matrix.scale(scale, scale);
				image.draw(baseData, matrix);
				
				var ba:ByteArray = PNGEncoder.encode(image);
				new FileReference().save(ba, "featureshot.png");
			}
		}
		
		static private function showKey(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.BACKQUOTE) {
				if ((e.target as Stage).getChildByName("ScreenshotAction") != null) {
					(e.target as Stage).removeChild(tooltip);
				} else {
					(e.target as Stage).addChild(tooltip);
				}
			}
		}
	}

}