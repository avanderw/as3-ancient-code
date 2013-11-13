package avdw.action {
	import avdw.decorator.border.SingleBorder;
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
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ThumbshotAction {
		static private const tooltip:Sprite = new Sprite();
		static private const name:String = "ThumbshotAction";
		
		static public function addTo(stage:Stage):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, captureScreenshot);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, showKey);
			tooltip.addChild(createField("thumbshot: Ctrl+F12", 5, 22));
			tooltip.graphics.beginFill(0xCCCCCC);
			tooltip.graphics.drawRect(0, 20, tooltip.width +10, tooltip.height + 4);
			tooltip.graphics.endFill();
			tooltip.name = name;
		}
		
		static private function captureScreenshot(e:KeyboardEvent):void {
			if (!e.shiftKey && e.ctrlKey && e.keyCode == Keyboard.F12) {
				var display:Stage = e.currentTarget as Stage;
				var baseData:BitmapData = new BitmapData(display.stageWidth, display.stageHeight, false);
				var render:Sprite = new Sprite();
				render.addChild(new Bitmap(baseData));
				var isDark:Boolean = averageLightness(render) < 122;
				var colorTransform:ColorTransform = (isDark)?new ColorTransform(1, 1, 1, 1, 35, 35, 35) : new ColorTransform(1, 1, 1, 1, -35, -35, -35);
				baseData.draw(display, null, colorTransform);
				
				
				var screenshot:TextField = createField("( Click Here )", 0, 0, 200, 20, false, "Verdana", 46, isDark ? 0xFFFFFF : 0x0);
				screenshot.alpha = 0.8;
				screenshot.x = (render.width - screenshot.width) / 2;
				screenshot.y = (render.height - screenshot.height) / 2;
				render.addChild(screenshot);
				
				var color:uint = isDark ? 0xEEEEEE : 0x333333;
				SingleBorder.addTo(render, color, 2);
				
				baseData.draw(render);
				
				var scale:Number = 0.5;
				var image:BitmapData = new BitmapData(baseData.width * scale, baseData.height * scale, false);
				var matrix:Matrix = new Matrix();
				matrix.scale(scale, scale);
				image.draw(baseData, matrix);
				
				var ba:ByteArray = PNGEncoder.encode(image);
				new FileReference().save(ba, "thumbshot.png");
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