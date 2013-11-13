package avdw.decorator.image {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import utils.color.getRGB;
	import utils.color.toRGBComponents;
	import avdw.color.colorize;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ImageDecorator {
		static private const Header:String = "header";
		static private const Footer:String = "footer";
		static private const Background:String = "background";
		static private const instance:ImageDecorator = new ImageDecorator();
		static private const zero:Point = new Point();
		static private var image:Bitmap;
		static private var type:String;
		
		static public function addHeader(ImageClass:Class):ImageDecorator {
			image = new ImageClass();
			type = Header;
			return instance;
		}
		
		static public function addFooter(ImageClass:Class):ImageDecorator {
			image = new ImageClass();
			type = Footer;
			return instance;
		}
		
		static public function addBackground(ImageClass:Class):ImageDecorator {
			image = new ImageClass();
			type = Background;
			return instance;
		}
		
		public function colorizedTo(color:uint):ImageDecorator {
			colorize(image.bitmapData, color);
			return instance;
		}
		
		public function to(display:*):ImageDecorator {
			var col:int, row:int;
			var matrix:Matrix;
			var width:int = display is Stage ? display.stageWidth : display.width;
			var height:int = display is Stage ? display.stageHeight : display.height;
			var cols:int = Math.ceil(width / image.width);
			var rows:int = Math.ceil(height / image.height);
			
			var render:Bitmap;
			switch (type) {
				case Header: 
					render = new Bitmap(new BitmapData(width, image.height, true, 0x0));
					for (col = 0; col < cols; col++) {
						matrix = new Matrix();
						matrix.translate(col * image.width, 0);
						render.bitmapData.draw(image, matrix);
					}
					display.addChild(render);
					break;
				case Footer: 
					render = new Bitmap(new BitmapData(width, image.height, true, 0x0));
					for (col = 0; col < cols; col++) {
						matrix = new Matrix();
						matrix.translate(col * image.width, 0);
						render.bitmapData.draw(image, matrix);
					}
					render.y = height - image.height;
					display.addChild(render);
					break;
				case Background: 
					render = new Bitmap(new BitmapData(width, height, true, 0x0));
					for (col = 0; col < cols; col++) {
						for (row = 0; row < rows; row++) {
							matrix = new Matrix();
							matrix.translate(col * image.width, row * image.height);
							render.bitmapData.draw(image, matrix);
						}
					}
					display.addChildAt(render, 0);
					break;
			}
			
			return instance;
		}
	}

}