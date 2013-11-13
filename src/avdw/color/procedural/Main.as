package avdw.color.procedural {
	import avdw.decorator.image.assets.mini.architecture.MiniArchitecture007;
	import avdw.decorator.image.assets.mini.leaves.MiniLeaves009;
	import avdw.decorator.image.assets.mottled.Mottled034;
	import avdw.decorator.image.ImageDecorator;
	import avdw.action.FeatureshotAction;
	import avdw.action.ScreenshotAction;
	import avdw.action.ThumbshotAction;
	import avdw.color.procedural.algorithm.AColorAlgorithm;
	import avdw.color.procedural.algorithm.HSLColorAlgorithm;
	import avdw.color.procedural.algorithm.HSVColorAlgorithm;
	import avdw.color.procedural.algorithm.RGBColorAlgorithm;
	import avdw.color.procedural.operation.InterpOperation;
	import avdw.color.procedural.operation.IOperation;
	import avdw.color.procedural.operation.NoOperation;
	import avdw.color.procedural.operation.OffsetOperation;
	import avdw.color.procedural.operation.RandomOperation;
	import avdw.color.procedural.operation.WalkOperation;
	import avdw.decorator.title.TextanimTitle;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import utils.color.toHexString;
	import utils.string.remove;
	import utils.textField.createField;
	import utils.color.RGBtoHSL;
	import utils.color.RGBtoHSV;
	import utils.color.getRGB;
	import utils.number.roundDecimalToPlace;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	[Frame(factoryClass="avdw.color.procedural.Preloader")]
	public class Main extends Sprite {
		private const algorithms:Array = [{label:"HSLColorAlgorithm", clazz:HSLColorAlgorithm, args:[{label:"H [0:360]"}, {label:"S [0:1]"}, {label:"L [0:1]"}] },
			{label:"HSVColorAlgorithm", clazz:HSVColorAlgorithm, args:[{label:"H [0:360]"}, {label:"S [0:1]"}, {label:"V [0:1]"}] },
			{label:"RGBColorAlgorithm", clazz:RGBColorAlgorithm, args:[{label:"R [0:255]"}, {label:"G [0:255]"}, {label:"B [0:255]"}] }
			];
		private const operations:Array = [
			{label: "NoOperation", clazz:NoOperation, args: [ { label: "value", type:Number } ] }, 
			{label: "RandomOperation", clazz:RandomOperation, args: [ { label: "low", type:Number }, { label: "high", type:Number } ] }, 
			{label: "OffsetOperation", clazz:OffsetOperation, args: [ { label: "value", type:Number }, { label: "min", type:Number }, { label: "max", type:Number }, {label:"bi-direction", type:Boolean} ] }, 
			{label: "WalkOperation", clazz:WalkOperation, args: [ { label: "value", type:Number }, { label: "min", type:Number }, { label: "max", type:Number }, { label:"bi-direction", type:Boolean } ] },
			{label: "InterpOperation", clazz:InterpOperation, args:[ { label:"start", type:Number }, { label:"end", type:Number }, { label:"interpFunc", type:Function }, { label:"samples", type:Number }, { label:"oscillate", type:Boolean } ] }	
			];
		private const easeFuncs:Array = [
			{label:"Linear", func:InterpOperation.Linear},
			{label:"BackEaseIn", func:InterpOperation.BackEaseIn},
			{label:"BackEaseInOut", func:InterpOperation.BackEaseInOut},
			{label:"BackEaseOut", func:InterpOperation.BackEaseOut},
			{label:"BounceEaseIn", func:InterpOperation.BounceEaseIn},
			{label:"BounceEaseInOut", func:InterpOperation.BounceEaseInOut},
			{label:"BounceEaseOut", func:InterpOperation.BounceEaseOut},
			{label:"CircEaseIn", func:InterpOperation.CircEaseIn},
			{label:"CircEaseInOut", func:InterpOperation.CircEaseInOut},
			{label:"CircEaseOut", func:InterpOperation.CircEaseOut},
			{label:"CubicEaseIn", func:InterpOperation.CubicEaseIn},
			{label:"CubicEaseInOut", func:InterpOperation.CubicEaseInOut},
			{label:"CubicEaseOut", func:InterpOperation.CubicEaseOut},
			{label:"ElasticEaseIn", func:InterpOperation.ElasticEaseIn},
			{label:"ElasticEaseInOut", func:InterpOperation.ElasticEaseInOut},
			{label:"ElasticEaseOut", func:InterpOperation.ElasticEaseOut},
			{label:"ExpoEaseIn", func:InterpOperation.ExpoEaseIn},
			{label:"ExpoEaseInOut", func:InterpOperation.ExpoEaseInOut},
			{label:"ExpoEaseOut", func:InterpOperation.ExpoEaseOut},
			{label:"QuadEaseIn", func:InterpOperation.QuadEaseIn},
			{label:"QuadEaseInOut", func:InterpOperation.QuadEaseInOut},
			{label:"QuadEaseOut", func:InterpOperation.QuadEaseOut},
			{label:"QuartEaseIn", func:InterpOperation.QuartEaseIn},
			{label:"QuartEaseInOut", func:InterpOperation.QuartEaseInOut},
			{label:"QuartEaseOut", func:InterpOperation.QuartEaseOut},
			{label:"QuintEaseIn", func:InterpOperation.QuintEaseIn},
			{label:"QuintEaseInOut", func:InterpOperation.QuintEaseInOut},
			{label:"QuintEaseOut", func:InterpOperation.QuintEaseOut},
			{label:"SineEaseIn", func:InterpOperation.SineEaseIn},
			{label:"SineEaseInOut", func:InterpOperation.SineEaseInOut},
			{label:"SineEaseOut", func:InterpOperation.SineEaseOut}
			];
		private var algorithmsCB:ComboBox;
		private var algorithm:AColorAlgorithm;
		private const colors:Vector.<uint> = new Vector.<uint>();
		private const renderSprite:Sprite = new Sprite();
		private var status:Label;
		
		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			CONFIG::debug {
				addChild(createField("debug mode", stage.stageWidth - 105, stage.stageHeight - 20, 100, 20, false, "Verdana", 9, 0xFF0000, TextFieldAutoSize.RIGHT));
				MonsterDebugger.initialize(this);
			}
			
			ImageDecorator.addBackground(Mottled034.Image).to(stage);
			ImageDecorator.addHeader(MiniArchitecture007.Image).to(stage);
			ImageDecorator.addFooter(MiniLeaves009.Image).to(stage);
			
			algorithmsCB = new ComboBox(stage, 10, 225, "algorithm", algorithms);
			algorithmsCB.addEventListener(Event.SELECT, algorithmsSelect);
			
			status = new Label(algorithmsCB, 0, -25, "");
			new PushButton(algorithmsCB, 105, 0, "compile", compile);
			new PushButton(algorithmsCB, 210, 0, "add", addColor);
			new PushButton(algorithmsCB, 315, 0, "remove", removeColor);
			new PushButton(algorithmsCB, 420, 0, "palette", generatePalette);
			
			new Label(algorithmsCB, 0, -107, ".: color breakdown");
			new ColorChooser(algorithmsCB, 100, -105, 0x0, selectColor);
			
			renderSprite.x = 0;
			renderSprite.y = -80;
			algorithmsCB.addChild(renderSprite);
			
			var blank:Sprite = new Sprite();
			blank.graphics.lineStyle(1);
			blank.graphics.beginFill(0xFFFFFF);
			blank.graphics.drawRect(5, 0, stage.stageWidth -10, 220);
			blank.graphics.endFill();
			blank.y = 115;
			blank.alpha = 0.5;
			addChild(blank);
			
			TextanimTitle.addTo(stage, "Procedural colors | avanderw.co.za", 24, true, StageAlign.TOP_LEFT, 80);
			ThumbshotAction.addTo(stage);
			FeatureshotAction.addTo(stage);
			ScreenshotAction.addTo(stage);
			
		}
		
		private function selectColor(e:Event):void {
			var color:ColorChooser = e.target as ColorChooser;
			var rgb:Object = getRGB(color.value);
			var hsl:Object = RGBtoHSL(rgb.r / 0xFF, rgb.g / 0xFF, rgb.b / 0xFF);
			var hsv:Object = RGBtoHSV(rgb.r / 0xFF, rgb.g / 0xFF, rgb.b / 0xFF);
			
			if (color.getChildByName("breakdown") != null) {
				color.removeChild(color.getChildByName("breakdown"));
			}
			
			var breakdown:Sprite = new Sprite();
			breakdown.name = "breakdown";
			
			new Label(breakdown, 0, -2, "Red: " + rgb.r);
			new Label(breakdown, 45, -2, "Green: " + rgb.g);
			new Label(breakdown, 100, -2, "Blue: " + rgb.b);
			new Label(breakdown, 150, -2, "Hue: " + hsl.h);
			new Label(breakdown, 200, -2, "Saturation: " + roundDecimalToPlace(hsv.s, 2));
			new Label(breakdown, 280, -2, "Luminance: " + roundDecimalToPlace(hsl.l, 2));
			new Label(breakdown, 370, -2, "Value: " + roundDecimalToPlace(hsv.v, 2));
			
			breakdown.x = 80;
			color.addChild(breakdown);
		}
		
		private function render():void {
			status.text = "";
			var cellW:Number = (stage.stageWidth-20) / colors.length;
			var g:Graphics = renderSprite.graphics;
			g.clear();
			g.lineStyle(1);
			for (var i:int = 0; i < colors.length; i++) {
				g.beginFill(colors[i]);
				g.drawRect(cellW * i, 0, cellW, 50);
				g.endFill();
			}
		}
		
		private function generatePalette(e:Event = null):void {
			var palette:Vector.<uint>;
			status.text = "";
			if (algorithm == null) {
				compile();
			}
			colors.splice(0, colors.length);
			try {
				palette = algorithm.generatePalette(20);
			} catch (e:Error) {
				status.text = "status: operation arguments need to be numbers";
			}
			for each (var color:uint in palette) {
				colors.push(color);
			}
			render();
			if (status.text == "") {
				status.text = "status: colors generated [colors.length = " + colors.length + "]";
			}
		}
		
		private function removeColor(e:Event = null):void {
			status.text = "";
			colors.shift();
			render();
			if (status.text == "") {
				status.text = "status: color removed [colors.length = " + colors.length + "]";
			}
		}
		
		private function addColor(e:Event = null):void {
			status.text = "";
			if (algorithm == null) {
				compile();
			}
			try {
				colors.push(algorithm.generateColor());
			} catch (e:Error) {
				status.text = "status: operation arguments need to be numbers";
			}
			render();
			if (status.text == "") {
				status.text = "status: color added [colors.length = " + colors.length + "]";
			}
		}
		
		private function compile(e:Event = null):void {
			status.text = "";
			var arg0:IOperation, arg1:IOperation, arg2:IOperation;
			var args:Sprite = algorithmsCB.getChildByName("args") as Sprite;
			if (args != null) {
				switch (args.numChildren) {
					case 3: 
						arg0 = getIOperation(args.getChildAt(0) as ComboBox);
						arg1 = getIOperation(args.getChildAt(1) as ComboBox);
						arg2 = getIOperation(args.getChildAt(2) as ComboBox);
						algorithm = new algorithmsCB.selectedItem.clazz(arg0, arg1, arg2);
						break;
				}
			} else {
				status.text = "status: please select an algorithm before compiling";
			}
			
			if (status.text == "") {
				status.text = "status: compiled color algorithm";
			}
		}
		
		private function getIOperation(operations:ComboBox):IOperation {
			var operation:IOperation;
			var arg0:*, arg1:*, arg2:*, arg3:*, arg4:*;
			var args:Sprite = operations.getChildByName("args") as Sprite;
			if (args != null) {
				switch (args.numChildren) {
					case 5: 
						arg4 = getValue(args.getChildAt(4));
					case 4: 
						arg3 = getValue(args.getChildAt(3));
					case 3: 
						arg2 = getValue(args.getChildAt(2));
					case 2: 
						arg1 = getValue(args.getChildAt(1));
					case 1: 
						arg0 = getValue(args.getChildAt(0));
				}
				
				switch (args.numChildren) {
					case 1: 
						operation = new operations.selectedItem.clazz(arg0);
						break;
					case 2: 
						operation = new operations.selectedItem.clazz(arg0, arg1);
						break;
					case 3: 
						operation = new operations.selectedItem.clazz(arg0, arg1, arg2);
						break;
					case 4: 
						operation = new operations.selectedItem.clazz(arg0, arg1, arg2, arg3);
						break;
					case 5: 
						operation = new operations.selectedItem.clazz(arg0, arg1, arg2, arg3, arg4);
						break;
				}
			} else {
				status.text = "status: please select all algorithm operations before compiling";
			}
			
			return operation;
		}
		
		private function getValue(input:Object):* {
			if (input is InputText) {
				return Number(input.text);
			} else if (input is CheckBox) {
				return Boolean(input.selected);
			} else if (input is ComboBox) {
				try {
				return input.selectedItem.func;
				} catch (e:Error) {
					status.text = "status: please select an interpolation function";
				}
			}
		}
		
		private function algorithmsSelect(e:Event):void {
			var ops:ComboBox;
			var display:Sprite = e.target as Sprite;
			if (display.getChildByName("args") != null) {
				display.removeChild(display.getChildByName("args"));
				display.removeChild(display.getChildByName("labels"));
			}
			
			var labels:Sprite = new Sprite();
			labels.name = "labels";
			var args:Sprite = new Sprite();
			args.name = "args";
			for (var i:int = 0; i < 3; i++) {
				new Label(labels, 0, 25 * i, algorithmsCB.selectedItem.args[i].label);
				ops = new ComboBox(args, 0, 25 * i, "operation", operations);
				ops.addEventListener(Event.SELECT, opsSelect);
			}
			labels.x = 25;
			labels.y = 25;
			display.addChild(labels);
			args.x = 80;
			args.y = 25;
			display.addChild(args);
		}
		
		private function opsSelect(e:Event):void {
			var display:Sprite = e.target as Sprite;
			if (display.getChildByName("args") != null) {
				display.removeChild(display.getChildByName("args"));
			}
			var args:Sprite = new Sprite();
			args.name = "args";
			for (var i:int = 0; i < e.target.selectedItem.args.length; i++) {
				switch (e.target.selectedItem.args[i].type) {
					case Number: 
						new InputText(args, 105 * i, 2, e.target.selectedItem.args[i].label);
						break;
					case Boolean: 
						new CheckBox(args, 105 * i, 4, e.target.selectedItem.args[i].label);
						break;
					case Function: 
						new ComboBox(args, 105 * i, 0, e.target.selectedItem.args[i].label, easeFuncs);
						break;
				}
			}
			args.x = 105;
			display.addChild(args);
		}
	
	}

}