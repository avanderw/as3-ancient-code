package avdw.decorator.background {
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	
	public class RadialGradientBackground {
		static private const name:String = "RadialGradientBackground";
		
		static public function addTo(display:*, colors:Array = null, ratios:Array = null):void {
			var width:int = display is Stage ? display.stageWidth : display.width;
			var height:int = display is Stage ? display.stageHeight : display.height;
			
			if (colors == null) {
				colors = [0x666666, 0x0];
			}
			
			var i:int;
			var alphas:Array = [];
			for (i = 0; i < colors.length; i++) {
				alphas[i] = 1;
			}
			
			if (ratios == null) {
				ratios = [];
				for (i = 0; i < colors.length; i++) {
					ratios[i] = i / (colors.length - 1) * 0xFF;
				}
			}
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width * 2, height * 2, 0, -width / 2, -height / 2);
			
			var bg:Sprite = new Sprite();
			bg.name = name;
			bg.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			bg.graphics.drawRect(0, 0, width, height);
			bg.graphics.endFill();
			
			display.addChildAt(bg, 0);
		}
		
		static public function removeFrom(display:*):void {
			if (display.getChildByName(name) != null) {
				display.removeChild(display.getChildByName(name));
			}
		}
	}
}