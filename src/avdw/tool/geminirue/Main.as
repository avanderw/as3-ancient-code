package avdw.tool.geminirue {
	import avdw.action.ScreenshotAction;
	import avdw.action.ThumbshotAction;
	import avdw.decorator.border.SingleBorder;
	import avdw.decorator.title.TextanimTitle;
	import avdw.preloader.SimplePreloader;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.RangeSlider;
	import com.bit101.components.Slider;
	import flash.display.Bitmap;
	import flash.display.ShaderParameter;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	/**
	 * idea from https://github.com/codesnik/rue
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	[Frame(factoryClass="avdw.tool.geminirue.Preloader")]
	public class Main extends Sprite {
		private var nodes:Vector.<Node>;
		[Embed(source="images/grid-connections.png")]
		private const GridConnections:Class;
		[Embed(source="images/Gemini-Rue-wallpaper.png")]
		private const BG:Class;
		[Embed(source="images/Monte-Carlo-Solver.png")]
		private const Title:Class;
		private var console:TextField;
		private var stateSlider:Slider;
		private var stepper:NumericStepper;
		private var centerText:TextFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
		
		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			ScreenshotAction.addTo(stage);
			ThumbshotAction.addTo(stage);
			
			addChild(new BG());
			
			var title:Bitmap = new Title();
			title.x = 90;
			title.y = 120;
			addChild(title);
			
			var spacing:int = 90;
			var gridRender:Sprite = new Sprite();
			console = new TextField();
			console.selectable = false;
			console.width = 680;
			console.y = 10;
			console.autoSize = TextFieldAutoSize.CENTER;
			console.backgroundColor = 0xEFEFEF;
			console.borderColor = 0;
			console.border = true;
			console.background = true;
			addChild(console);
			write("Make all the nodes green!");
			
			//new PushButton(stage, 400, 50, "randomize puzzle", randomiseState);
			//new PushButton(stage, 400, 25, "set puzzle", setupState);
			
			nodes = createGraph();
			setState(2); // not all states are solveable
			randomiseState();
			
			// render and spacing
			var grid:Bitmap = new GridConnections();
			grid.y += 8;
			gridRender.addChild(grid);
			var i:int;
			for (i = 0; i < 10; i++) {
				gridRender.addChild(nodes[i]);
				nodes[i].x = i % 3 * spacing;
				nodes[i].y = Math.floor(i / 3) * spacing;
				nodes[i].buttonMode = true;
			}
			
			addChild(gridRender);
			gridRender.addEventListener(MouseEvent.CLICK, click);
			gridRender.x = (stage.stageWidth - gridRender.width) / 2 + 120;
			gridRender.y = (stage.stageHeight - gridRender.height) / 2 + 40;
			
			var sliderArea:Sprite = new Sprite();
			stateSlider = new Slider(Slider.HORIZONTAL, sliderArea, 0, 20, setupState);
			new Label(sliderArea, 20, -23, "Puzzle Number").textField.textColor = 0;
			stateSlider.minimum = 0;
			stateSlider.maximum = 1023;
			addChild(sliderArea);
			sliderArea.x = 140;
			sliderArea.y = 300;
			stepper = new NumericStepper(sliderArea, 0, 0, setupStateNumeric);
			stepper.maximum = 1023;
			stepper.minimum = 0;
			stepper.x = stateSlider.x + (stateSlider.width - stepper.width) / 2;
			
			new PushButton(stage, sliderArea.x, sliderArea.y + +stateSlider.y + stateSlider.height + 5, "calculate solution", randomSolver);
			
			sliderArea.graphics.beginFill(0xFFFFFF, 0.85);
			sliderArea.graphics.drawRoundRect(-10, -25, sliderArea.width + 20, sliderArea.height-30, 5, 5);
			sliderArea.graphics.endFill();
			
			stateSlider.value = getState();
			stepper.value = stateSlider.value;
			
			TextanimTitle.addTo(stage, "monte carlo solver | avanderw.co.za", 24, false, StageAlign.BOTTOM_RIGHT, 10);
		}
		
		private function setupStateNumeric(e:Event):void {
			stateSlider.value = stepper.value;
			setupState();
		}
		
		private function setupState(e:Event = null):void {
			console.text = "";
			stateSlider.value = Math.floor(stateSlider.value);
			stepper.value = stateSlider.value;
			setState(stateSlider.value);
		}
		
		private function randomiseState(e:Event = null):void {
			var n:Node;
			for each (n in nodes) {
				if (Math.random() < 0.5) {
					n.click();
				}
				n.update();
			}
		}
		
		private function getState():int {
			var i:int;
			var bits:int = 0;
			for (i = 0; i < 10; i++) {
				bits |= (nodes[i].on ? 1 : 0) << i;
			}
			
			return bits;
		}
		
		private function bitString(bits:int):String {
			var s:String = "";
			var i:int;
			
			for (i = 0; i < 10; i++) {
				s += "" + ((bits >> i) & 1);
			}
			
			return s;
		}
		
		private function setState(bits:int):void {
			var i:int;
			for (i = 0; i < 10; i++) {
				nodes[i].on = ((bits >> i) & 1) == 1;
				nodes[i].update();
			}
		}
		
		private function createGraph():Vector.<Node> {
			var nodes:Vector.<Node> = new Vector.<Node>();
			nodes.push(new Node(new ButtonAsset.Green01, new ButtonAsset.Red01));
			nodes.push(new Node(new ButtonAsset.Green02, new ButtonAsset.Red02));
			nodes.push(new Node(new ButtonAsset.Green03, new ButtonAsset.Red03));
			nodes.push(new Node(new ButtonAsset.Green04, new ButtonAsset.Red04));
			nodes.push(new Node(new ButtonAsset.Green05, new ButtonAsset.Red05));
			nodes.push(new Node(new ButtonAsset.Green06, new ButtonAsset.Red06));
			nodes.push(new Node(new ButtonAsset.Green07, new ButtonAsset.Red07));
			nodes.push(new Node(new ButtonAsset.Green08, new ButtonAsset.Red08));
			nodes.push(new Node(new ButtonAsset.Green09, new ButtonAsset.Red09));
			nodes.push(new Node(new ButtonAsset.Green10, new ButtonAsset.Red10));
			
			// connections
			nodes[0].influences = [nodes[1], nodes[3]];
			nodes[1].influences = [nodes[0], nodes[2], nodes[3], nodes[4]];
			nodes[2].influences = [nodes[1], nodes[5]];
			nodes[3].influences = [nodes[0], nodes[1], nodes[6]];
			nodes[4].influences = [nodes[1], nodes[5], nodes[7]];
			nodes[5].influences = [nodes[2], nodes[4], nodes[7], nodes[8]];
			nodes[6].influences = [nodes[3], nodes[7], nodes[9]];
			nodes[7].influences = [nodes[4], nodes[5], nodes[6]];
			nodes[8].influences = [nodes[5]];
			nodes[9].influences = [nodes[6]];
			
			return nodes;
		}
		
		private function write(text:String):void {
			console.appendText(text + "\n");
			console.setTextFormat(centerText);
		}
		
		private function click(e:MouseEvent):void {
			stateSlider.value = getState();
			stepper.value = stateSlider.value;
			if (allOn()) {
				console.text = "";
				write("Well done!");
			}
		}
		
		private function randomSolver(e:Event = null):void {
			var i:int;
			var iter:int;
			var rand:int;
			var n:Node;
			var solution:String;
			var walk:String;
			var state:int = getState();
			var maxAttempts:int = 64;
			var maxIter:int = 999;
			var avgIter:int;
			var shortest:int = 1500;
			for (i = 0; i < maxAttempts; i++) {
				walk = "";
				iter = 0;
				while (!allOn()) {
					rand = Math.random() * 10;
					nodes[rand].click();
					walk += (rand + 1) + " > ";
					iter++;
					if (iter > maxIter) {
						break;
					}
				}
				avgIter += iter;
				walk = walk.substr(0, walk.length - 2);
				
				if (solution == null || solution.length > walk.length) {
					solution = walk;
					shortest = iter;
				}
				setState(state);
			}
			
			avgIter /= maxAttempts;
			
			console.text = "";
			write("Monte Carlo simulation ran on puzzle number " + getState() + " ( " + bitString(getState()) + " )");
			write("The simulation ran " + maxAttempts + " times.");
			if (solution.length < 1000) {
				write("The average steps taken to get to a solution were " + avgIter + ".");
				write("The shortest solution found was " + shortest + " steps.");
				write(solution);
			} else {
				write("No viable solution was found! It is probably unsolveable.");
				write("The simulation stopped after 1500 steps on each attempt.");
			}
		}
		
		private function allOn():Boolean {
			var n:Node;
			for each (n in nodes) {
				if (!n.on) {
					return false;
				}
			}
			return true;
		}
	}

}

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.ByteArray;

class Node extends Sprite {
	public var influences:Array;
	public var on:Boolean;
	private var onImage:Bitmap;
	private var offImage:Bitmap;
	private var image:Bitmap;
	
	public function Node(onImage:Bitmap = null, offImage:Bitmap = null):void {
		this.on = true;
		this.onImage = onImage;
		this.offImage = offImage;
		update();
		addChild(image);
		addEventListener(MouseEvent.CLICK, click);
	}
	
	public function click(e:MouseEvent = null):void {
		change(true);
	}
	
	public function change(propogate:Boolean = false):void {
		on = !on;
		if (propogate) {
			var n:Node;
			for each (n in influences) {
				n.change();
			}
		}
		update();
	}
	
	public function update():void {
		if (image != null)
			removeChild(image);
		image = on ? onImage : offImage;
		addChild(image);
	}
}

class ButtonAsset {
	[Embed(source="images/green_01.png")]
	static public const Green01:Class;
	[Embed(source="images/green_02.png")]
	static public const Green02:Class;
	[Embed(source="images/green_03.png")]
	static public const Green03:Class;
	[Embed(source="images/green_04.png")]
	static public const Green04:Class;
	[Embed(source="images/green_05.png")]
	static public const Green05:Class;
	[Embed(source="images/green_06.png")]
	static public const Green06:Class;
	[Embed(source="images/green_07.png")]
	static public const Green07:Class;
	[Embed(source="images/green_08.png")]
	static public const Green08:Class;
	[Embed(source="images/green_09.png")]
	static public const Green09:Class;
	[Embed(source="images/green_10.png")]
	static public const Green10:Class;
	
	[Embed(source="images/red_01.png")]
	static public const Red01:Class;
	[Embed(source="images/red_02.png")]
	static public const Red02:Class;
	[Embed(source="images/red_03.png")]
	static public const Red03:Class;
	[Embed(source="images/red_04.png")]
	static public const Red04:Class;
	[Embed(source="images/red_05.png")]
	static public const Red05:Class;
	[Embed(source="images/red_06.png")]
	static public const Red06:Class;
	[Embed(source="images/red_07.png")]
	static public const Red07:Class;
	[Embed(source="images/red_08.png")]
	static public const Red08:Class;
	[Embed(source="images/red_09.png")]
	static public const Red09:Class;
	[Embed(source="images/red_10.png")]
	static public const Red10:Class;
}
