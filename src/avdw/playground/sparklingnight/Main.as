package avdw.playground.sparklingnight {
	import avdw.action.FeatureshotAction;
	import avdw.action.ScreenshotAction;
	import avdw.action.ThumbshotAction;
	import avdw.decorator.background.FlatBackground;
	import avdw.decorator.border.SingleBorder;
	import avdw.decorator.title.TextanimTitle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.counters.Pulse;
	import org.flintparticles.common.counters.SineCounter;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.MassInit;
	import org.flintparticles.twoD.actions.ApproachNeighbours;
	import org.flintparticles.twoD.actions.BoundingBox;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.actions.Friction;
	import org.flintparticles.twoD.actions.GravityWell;
	import org.flintparticles.twoD.actions.AntiGravity;
	import org.flintparticles.twoD.actions.MouseAntiGravity;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.actions.SpeedLimit;
	import org.flintparticles.twoD.actions.WrapAroundBox;
	import org.flintparticles.twoD.actions.ZonedAction;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.renderers.BitmapLineRenderer;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.renderers.PixelRenderer;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class Main extends Sprite {
		
		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private static const ZERO_POINT:Point = new Point();
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			FlatBackground.addTo(stage);
			Mouse.hide();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var rect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			var renderer:PixelRenderer = new PixelRenderer(rect);
			
			var bmp:Bitmap;
			var i:int, tx:int, ty:int;
			var emitter:Emitter2D = new Emitter2D();
			with (emitter) {
				counter = new Steady(50);
				
				addInitializer(new ColorInit(0xFF9966FF, 0xFF3399FF));
				tx = Math.random() * stage.stageWidth;
				ty = Math.random() * stage.stageHeight;
				addInitializer(new Position(new RectangleZone(0, 0, stage.stageWidth, stage.stageHeight)));
				
				for (i = 0; i < 4; i++) {
					tx = Math.random() * stage.stageWidth;
					ty = Math.random() * stage.stageHeight;
					
					addAction(new DeathZone(new DiscZone(new Point(tx, ty), 8)));
					addAction(new GravityWell(50, tx, ty));
					
					bmp = new Bitmap(createBlackhole(36, 36));
					bmp.x = tx - 16;
					bmp.y = ty - 16;
					addChild(bmp);
					/*graphics.lineStyle(1, 0xFFFFFF);
					 graphics.drawCircle(tx, ty, 5);*/
					
				}
				
				for (i = 0; i < 3; i++) {
					tx = Math.random() * stage.stageWidth;
					ty = Math.random() * stage.stageHeight;
					addAction(new AntiGravity(15, tx, ty));
					bmp = new Bitmap(createSmokyCircle(32, 32, 0xECECEC));
					bmp.x = tx - 16;
					bmp.y = ty - 16;
					addChild(bmp);
					/*graphics.lineStyle(1, 0x666666);
					 graphics.drawCircle(tx, ty, 5);*/
					
				}
				addAction(new RandomDrift(5, 5));
				addAction(new WrapAroundBox(0, 0, stage.stageWidth, stage.stageHeight));
				addAction(new SpeedLimit(50));
				addAction(new MouseAntiGravity(25, renderer));
				addAction(new Move());
			}
			
			renderer.blendMode = BlendMode.ADD;
			renderer.addFilter(new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, .5, 0]));
			renderer.addEmitter(emitter);
			
			emitter.start();
			emitter.runAhead(10);
			
			var sparkle:Bitmap = new Bitmap(new BitmapData(stage.stageWidth/4, stage.stageHeight/4, true, 0x0), PixelSnapping.NEVER, true);
			sparkle.blendMode = BlendMode.ADD;
			sparkle.scaleX = sparkle.scaleY = 4;
			
			var num:Number = 0;
			var indent:Number = 0;
			var transform:Matrix = new Matrix(1 / 4, 0, 0, 1 / 4, 0, 0);
			addEventListener(Event.ENTER_FRAME, function(e:Event):void {
					sparkle.bitmapData.fillRect(sparkle.bitmapData.rect, 0x0);
					sparkle.bitmapData.draw(renderer.bitmapData, transform);
					graphics.clear();
					graphics.lineStyle(1, 0x666666);
					
					for (i = 0; i < 5; i++) {
						graphics.moveTo(emitter.particlesArray[i].x - indent, emitter.particlesArray[i].y);
						graphics.lineTo(emitter.particlesArray[i].x + indent, emitter.particlesArray[i].y);
						graphics.moveTo(emitter.particlesArray[i].x, emitter.particlesArray[i].y - indent);
						graphics.lineTo(emitter.particlesArray[i].x, emitter.particlesArray[i].y + indent);
						graphics.drawCircle(emitter.particlesArray[i].x, emitter.particlesArray[i].y, indent / 2);
					}
					indent = Math.sin(num) * 15;
					num += Math.PI / 45;
					
					graphics.drawCircle(mouseX, mouseY, (15 - indent) / 3 + 5);
					graphics.drawCircle(mouseX, mouseY, (15 - indent) / 4 + 3);
					graphics.drawCircle(mouseX, mouseY, (15 - indent) / 6 + 1);
				});
			
			addChild(sparkle);
			addChild(renderer);
			TextanimTitle.addTo(stage, "Sparking night | avanderw.co.za", 24, false, StageAlign.BOTTOM_RIGHT, 13);
			SingleBorder.addTo(stage, 0xC9F1FA, 2, 3);
			ScreenshotAction.addTo(stage);
			FeatureshotAction.addTo(stage);
			ThumbshotAction.addTo(stage);
		}
		
		private function createBlackhole(w:Number, h:Number):BitmapData {
			var buf:BitmapData = new BitmapData(w, h);
			var buf2:BitmapData = new BitmapData(w, h);
			var buf3:BitmapData = new BitmapData(w, h);
			var sh:Shape = new Shape();
			var colors:Array = [0xFFFFFF, 0xFFFFFF, 0x0];var alphas:Array = [1, 1, 1];var ratios:Array = [0, 127, 255];var matrix:Matrix = new Matrix();
			
			matrix.createGradientBox(w, h, 0, 0, 0);
			sh.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			sh.graphics.drawRect(0, 0, w, h);
			sh.graphics.endFill();
			
			buf3.draw(sh);
			buf.perlinNoise(w, w, 4, Math.random() * 0xffff, true, true, BitmapDataChannel.BLUE);
			buf.draw(buf3, null, null, BlendMode.MULTIPLY);
			
			colors = [0xFFFFFF, 0xABABAB, 0xCBCBCB];
			alphas = [1, 1, 1];
			ratios = [45, 135, 215];
			matrix.createGradientBox(w, h, Math.random() * 2 * Math.PI);
			sh.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			sh.graphics.drawRect(0, 0, w, h);
			sh.graphics.endFill();
			
			buf2.perlinNoise(buf2.width / 2, buf2.height / 2, 4, Math.random() * 0xffff, true, false, BitmapDataChannel.RED | BitmapDataChannel.GREEN | BitmapDataChannel.BLUE, true);
			buf2.draw(sh, null, null, BlendMode.ADD);
			buf2.copyChannel(buf, buf.rect, ZERO_POINT, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
			
			buf2.colorTransform(buf2.rect, new ColorTransform(-1, -1, -1, 1, 255, 255, 255, 0));
			return buf2;
		}
		
		private function createSmokyCircle(w:int, h:int, col:int = 0xffffff):BitmapData {
			var buf:BitmapData = new BitmapData(w, h);
			var buf2:BitmapData = new BitmapData(w, h);
			var buf3:BitmapData = new BitmapData(w, h);
			var sh:Shape = new Shape();
			var colors:Array = [0xd0d0d0, 0xa0a0a0, 0x000000];var alphas:Array = [1, 1, 1];var ratios:Array = [0, 127, 255];var matrix:Matrix = new Matrix();
			
			buf.perlinNoise(w, w, 4, Math.random() * 0xffff, true, true, 4);
			matrix.createGradientBox(w, h, 0, 0, 0);
			sh.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			sh.graphics.drawRect(0, 0, w, h);
			sh.graphics.endFill();
			
			buf3.draw(sh);
			buf.draw(buf3, null, null, BlendMode.MULTIPLY);
			
			colors = [col, 0, 0];
			alphas = [1, 1, 1];
			ratios = [0, 192, 255];
			matrix.createGradientBox(w, h, 45);
			sh.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			sh.graphics.drawRect(0, 0, w, h);
			sh.graphics.endFill();
			
			buf2.perlinNoise(buf2.width, buf2.height, 4, Math.random() * 0xffff, true, false, 7, true);
			buf2.draw(sh, null, null, BlendMode.ADD);
			
			buf2.copyChannel(buf, buf.rect, ZERO_POINT, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
			return buf2;
		}
	
	}

}