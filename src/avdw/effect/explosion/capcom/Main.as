package avdw.effect.explosion.capcom {
	//import avdw.decorator.border.BasicBorder;
	import avdw.decorator.image.assets.mottled.Mottled006;
	import avdw.decorator.image.ImageDecorator;
	import avdw.decorator.title.TextanimTitle;
	import avdw.demo.DemoFramework;
	import com.adobe.images.PNGEncoder;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import com.demonsters.debugger.MonsterDebugger;
	import utils.textField.createField;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Main extends Sprite {
		[Embed(source="CapcomExplosion.as", mimeType="application/octet-stream")]
		private const explosionClass:Class;
		public function Main() {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			var start:int;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			ImageDecorator.addBackground(Mottled006.Image).to(stage);
			DemoFramework.init(stage);
			TextanimTitle.addTo(stage, "Capcom Explosion | avanderw.co.za");
			
			var explosion:CapcomExplosion = new CapcomExplosion();
			
			///
			var generationTime:Label = new Label(this, 5, 425, "please be patient when generating (" + Number(System.totalMemory / 1024 / 1024).toFixed(2) + "MB)");
			/*new PushButton(this, 5, 420, "randomize", function():void {
			   seed.value = Math.random() * uint.MAX_VALUE;
			   explosion.seed = seed.value;
			 });*/
			new PushButton(this, 5, 450, "generate", function():void {
					start = getTimer();
					explosion.generate();
					generationTime.text = "generation time: " + (getTimer() - start) + "ms (" + Number(System.totalMemory / 1024 / 1024).toFixed(2) + "MB)";
					explosion.animation.play();
				});
			new PushButton(this, 105, 450, "play", function():void {
					if (explosion.animation == null) {
						start = getTimer();
						explosion.generate();
						generationTime.text = "generation time: " + (getTimer() - start) + "ms (" + Number(System.totalMemory / 1024 / 1024).toFixed(2) + "MB)";
					}
					explosion.animation.play();
				});
			new PushButton(this, 205, 450, "save", function():void {
					if (explosion.animation == null) {
						start = getTimer();
						explosion.generate();
						generationTime.text = "generation time: " + (getTimer() - start) + "ms (" + Number(System.totalMemory / 1024 / 1024).toFixed(2) + "MB)";
					}
					explosion.animation.play();
					explosion.animation.save();
				});
			new PushButton(this, stage.stageWidth - 105, 5, "Get the code", function():void {
				var ba:ByteArray = new explosionClass() as ByteArray;
				new FileReference().save(ba, "CapcomExplosion.as");
			});
			///
			var generalControls:Sprite = new Sprite();
			new Label(generalControls, 0, 0, "seed");
			var seed:NumericStepper = new NumericStepper(generalControls, 75, 0, function():void {
					explosion.seed = seed.value;
				});
			seed.value = explosion.seed;
			
			new Label(generalControls, 0, 25, "scale");
			var scaleSize:NumericStepper = new NumericStepper(generalControls, 75, 25, function():void {
					explosion.scaleSize = scaleSize.value;
				});
			scaleSize.value = explosion.scaleSize;
			new Label(generalControls, 0, 50, "fuzziness");
			var fuzziness:NumericStepper = new NumericStepper(generalControls, 75, 50, function():void {
					explosion.fuzziness = fuzziness.value;
				});
			fuzziness.value = explosion.fuzziness;
			generalControls.x = 210;
			generalControls.y = 25;
			addChild(generalControls);
			
			///
			var glowControls:Sprite = new Sprite();
			new Label(glowControls, 0, 0, "glow controls");
			new Label(glowControls, 0, 25, "color");
			var glowColor:ColorChooser = new ColorChooser(glowControls, 75, 25, explosion.glowColor, function():void {
					explosion.glowColor = glowColor.value;
				});
			new Label(glowControls, 0, 50, "size");
			var glowSize:NumericStepper = new NumericStepper(glowControls, 75, 50, function():void {
					explosion.glowSize = glowSize.value;
				});
			glowSize.value = explosion.glowSize;
			new Label(glowControls, 0, 75, "strength");
			var glowStrength:NumericStepper = new NumericStepper(glowControls, 75, 75, function():void {
					explosion.glowStrength = glowStrength.value;
				});
			glowStrength.value = explosion.glowStrength;
			glowControls.x = 400;
			glowControls.y = 360;
			addChild(glowControls);
			
			///
			var flareControls:Sprite = new Sprite();
			new Label(flareControls, 0, 0, "flare controls");
			new Label(flareControls, 0, 25, "particles");
			var flareParticles:NumericStepper = new NumericStepper(flareControls, 75, 25, function():void {
					explosion.flareParticles = flareParticles.value;
				});
			flareParticles.value = explosion.flareParticles;
			new Label(flareControls, 0, 50, "duration");
			var flareDuration:NumericStepper = new NumericStepper(flareControls, 75, 50, function():void {
					explosion.flareDuration = flareDuration.value;
				});
			flareDuration.value = explosion.flareDuration;
			new Label(flareControls, 0, 75, "edge color");
			var flareEdgeColor:ColorChooser = new ColorChooser(flareControls, 75, 75, explosion.flareEdgeColor[0], function():void {
					explosion.flareEdgeColor[0] = flareEdgeColor.value;
				});
			new Label(flareControls, 0, 100, "colors");
			addColorComponent(flareControls, 75, 100, explosion.flareColors, 0);
			addColorComponent(flareControls, 175, 100, explosion.flareColors, 1);
			addColorComponent(flareControls, 75, 120, explosion.flareColors, 2);
			addColorComponent(flareControls, 175, 120, explosion.flareColors, 3);
			addColorComponent(flareControls, 75, 140, explosion.flareColors, 4);
			addColorComponent(flareControls, 175, 140, explosion.flareColors, 5);
			addColorComponent(flareControls, 75, 160, explosion.flareColors, 6);
			addColorComponent(flareControls, 175, 160, explosion.flareColors, 7);
			addColorComponent(flareControls, 75, 180, explosion.flareColors, 8);
			flareControls.x = 400;
			flareControls.y = 5;
			addChild(flareControls);
			
			///
			var smokeControls:Sprite = new Sprite();
			new Label(smokeControls, 0, 0, "smoke controls");
			new Label(smokeControls, 0, 25, "size");
			var smokeSize:NumericStepper = new NumericStepper(smokeControls, 75, 25, function():void {
					explosion.smokeSize = smokeSize.value;
				});
			smokeSize.value = explosion.smokeSize;
			new Label(smokeControls, 0, 50, "particles");
			var smokeParticles:NumericStepper = new NumericStepper(smokeControls, 75, 50, function():void {
					explosion.smokeParticles = smokeParticles.value;
				});
			smokeParticles.value = explosion.smokeParticles;
			new Label(smokeControls, 0, 75, "duration");
			var smokeDuration:NumericStepper = new NumericStepper(smokeControls, 75, 75, function():void {
					explosion.smokeDuration = smokeDuration.value;
				});
			smokeDuration.value = explosion.smokeDuration;
			new Label(smokeControls, 0, 100, "edge color");
			var smokeEdgeColor:ColorChooser = new ColorChooser(smokeControls, 75, 100, explosion.smokeEdgeColor[0], function():void {
					explosion.smokeEdgeColor[0] = smokeEdgeColor.value;
				});
			new Label(smokeControls, 0, 125, "colors");
			addColorComponent(smokeControls, 75, 125, explosion.smokeColors, 0);
			addColorComponent(smokeControls, 175, 125, explosion.smokeColors, 1);
			smokeControls.x = 5;
			smokeControls.y = 240;
			addChild(smokeControls);
			
			///
			var explodeControls:Sprite = new Sprite();
			new Label(explodeControls, 0, 0, "exploding controls");
			new Label(explodeControls, 0, 25, "particles");
			var explodeParticles:NumericStepper = new NumericStepper(explodeControls, 75, 25, function():void {
					explosion.explodeParticles = explodeParticles.value;
				});
			explodeParticles.value = explosion.explodeParticles;
			new Label(explodeControls, 0, 50, "duration");
			var explodeDuration:NumericStepper = new NumericStepper(explodeControls, 75, 50, function():void {
					explosion.explodeDuration = explodeDuration.value;
				});
			explodeDuration.value = explosion.explodeDuration;
			new Label(explodeControls, 0, 75, "spread");
			var explodeSpread:NumericStepper = new NumericStepper(explodeControls, 75, 75, function():void {
					explosion.explodeSpread = explodeSpread.value;
				});
			explodeSpread.value = explosion.explodeSpread;
			new Label(explodeControls, 0, 100, "edge color");
			var explodeEdgeColor:ColorChooser = new ColorChooser(explodeControls, 75, 100, explosion.explodeEdgeColor[0], function():void {
					explosion.explodeEdgeColor[0] = explodeEdgeColor.value;
				});
			new Label(explodeControls, 0, 125, "colors");
			addColorComponent(explodeControls, 75, 125, explosion.explodeColors, 0);
			addColorComponent(explodeControls, 175, 125, explosion.explodeColors, 1);
			addColorComponent(explodeControls, 75, 145, explosion.explodeColors, 2);
			addColorComponent(explodeControls, 175, 145, explosion.explodeColors, 3);
			addColorComponent(explodeControls, 75, 165, explosion.explodeColors, 4);
			addColorComponent(explodeControls, 175, 165, explosion.explodeColors, 5);
			addColorComponent(explodeControls, 75, 185, explosion.explodeColors, 6);
			addColorComponent(explodeControls, 175, 185, explosion.explodeColors, 7);
			addColorComponent(explodeControls, 75, 205, explosion.explodeColors, 8);
			explodeControls.x = 5;
			explodeControls.y = 5;
			addChild(explodeControls);
			
			///
			var trailControls:Sprite = new Sprite();
			new Label(trailControls, 0, 0, "trail controls");
			new Label(trailControls, 0, 25, "particles");
			var trailParticles:NumericStepper = new NumericStepper(trailControls, 75, 25, function():void {
					explosion.trailParticles = trailParticles.value;
				});
			trailParticles.value = explosion.trailParticles;
			new Label(trailControls, 0, 50, "duration");
			var trailDuration:NumericStepper = new NumericStepper(trailControls, 75, 50, function():void {
					explosion.trailDuration = trailDuration.value;
				});
			trailDuration.value = explosion.trailDuration;
			new Label(trailControls, 0, 75, "edge color");
			var trailEdgeColor:ColorChooser = new ColorChooser(trailControls, 75, 75, explosion.trailEdgeColor[0], function():void {
					explosion.trailEdgeColor[0] = trailEdgeColor.value;
				});
			new Label(trailControls, 0, 100, "colors");
			addColorComponent(trailControls, 75, 100, explosion.trailColors, 0);
			addColorComponent(trailControls, 175, 100, explosion.trailColors, 1);
			addColorComponent(trailControls, 75, 120, explosion.trailColors, 2);
			trailControls.x = 400;
			trailControls.y = 210;
			addChild(trailControls);
			
			explosion.x = 300;
			explosion.y = 280;
			addChild(explosion);
		
		}
		
		private function addColorComponent(component:Sprite, x:Number, y:Number, array:Vector.<uint>, i:Number):void {
			var color:ColorChooser = new ColorChooser(component, x, y, array[i], function():void {
					array[i] = color.value;
				});
		}
	
	}

}