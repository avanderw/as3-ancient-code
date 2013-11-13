package avdw.decorator.background {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	
	public class FlatBackground {
		static private const name:String = "FlatBackground";
		
		static public function addTo(display:*, color:uint = 0x0):void {
			var width:int = display is Stage ? display.stageWidth : display.width;
			var height:int = display is Stage ? display.stageHeight : display.height;
			
			var bmp:Bitmap = new Bitmap(new BitmapData(width, height, false, color));
			bmp.name = name;
			display.addChildAt(bmp, 0);
		}
		
		static public function removeFrom(display:*):void {
			if (display.getChildByName(name) != null) {
				display.removeChild(display.getChildByName(name));
			}
		}
	
	}

}