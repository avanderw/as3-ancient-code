package avdw.lib.decorator.border 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class TwoToneBorder 
	{
		
		public function TwoToneBorder() 
		{
			
		}

		private static const name:String = "TwoToneBorder";
		private static const shadow:DropShadowFilter = new DropShadowFilter();
		private static const glow:GlowFilter = new GlowFilter(0xC9F1FA);
		
		public static function addTo(display:*, isLightBackground:Boolean = true, thickness:int = 3):void {
			var border:Sprite = new Sprite();
			border.filters = [isLightBackground ? shadow : glow];
			var offset:int = (thickness - 1) / 2;
			var width:int = display is Stage ? display.stageWidth : display.width;
			var height:int = display is Stage ? display.stageHeight : display.height;
			var colors:Vector.<uint> = isLightBackground ? Vector.<uint>([0x333333, 0x666666]) : Vector.<uint>([0xCCCCCC, 0x999999]);
			border.graphics.lineStyle(thickness, colors[0]);
			border.graphics.drawRect(offset, offset, width - 2 * offset, height - 2 * offset);
			border.graphics.lineStyle(thickness, colors[1]);
			border.graphics.drawRect(thickness + offset, thickness + offset, width - 2 * (offset + thickness), height - 2 * (offset + thickness));
			border.name = name;
			display.addChild(border);
		}
		
		public static function removeFrom(display:*):void {
			if (display.getChildByName(name) != null) {
				display.removeChild(display.getChildByName(name));
			}
		}
		
	}

}