package avdw.decorator.border 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class SingleBorder 
	{
		private static const name:String = "SingleBorder";
		
		public static function addTo(display:*, color:uint = 0x0, thickness:int = 1, inset:int = 0):void {
			var width:int = display is Stage ? display.stageWidth : display.width;
			var height:int = display is Stage ? display.stageHeight : display.height;
			
			var offset:Number = thickness / 2 + inset;
			var border:Sprite = new Sprite();
			border.name = name;
			border.graphics.lineStyle(thickness, color);
			border.graphics.drawRect(offset, offset, width - 2 * offset, height - 2 * offset);
			display.addChild(border);
		}
		
		public static function removeFrom(display:*):void {
			if (display.getChildByName(name) != null) {
				display.removeChild(display.getChildByName(name));
			}
		}
	}

}